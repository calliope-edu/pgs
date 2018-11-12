import CoreBluetooth
import Foundation

public typealias CharacteristicNotifyBlock = (Characteristic, Data) -> Void

public final class Characteristic {
    public let uuid: CBUUID
    public var isValid: Bool { return core != nil }
    public var timeoutRead: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)
    public var timeoutWrite: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)
    public var notifyBlock: CharacteristicNotifyBlock?

    fileprivate let service: Service
    fileprivate var core: CBCharacteristic?

    fileprivate init(service: Service, uuid: CBUUID) {
        self.service = service
        self.uuid = uuid
    }

    public func setNotify(enabled: Bool) throws {
        guard let core = core else {
            ERR("no core notify")
            throw "no core notify"
        }
        service.peripheral.core.setNotifyValue(enabled, for: core)
    }

    fileprivate let readSignal = DispatchGroup()
    public func read() throws -> Data {
        guard let core = core else {
            ERR("no core read")
            throw "no core read"
        }

        let timeout = DispatchTime.now() + timeoutRead

        readSignal.enter()
        service.peripheral.core.readValue(for: core)

        if readSignal.wait(timeout: timeout) == .timedOut {
            ERR("read timed out")
            throw "read timed out"
        }

        return core.value ?? Data()
    }

    fileprivate let writeSignal = DispatchGroup()
    public func write(data: Data) throws {
        guard let core = core else {
            ERR("no core write")
            throw "no core write"
        }

        let timeout = DispatchTime.now() + timeoutWrite

        writeSignal.enter()
        service.peripheral.core.writeValue(data, for: core, type: .withResponse)

        if writeSignal.wait(timeout: timeout) == .timedOut {
            ERR("write timed out")
            throw "write timed out"
        }
    }
}

public final class Service {
    public var characteristics: [CBUUID: Characteristic] = [:]
    public let uuid: CBUUID
    public var isValid: Bool { return core != nil }

    fileprivate let peripheral: Peripheral
    fileprivate var core: CBService?

    fileprivate init(peripheral: Peripheral, uuid: CBUUID) {
        self.peripheral = peripheral
        self.uuid = uuid
    }

    @discardableResult
    func find(characteristic uuid: CBUUID) -> Characteristic {
        if let characteristic = characteristics[uuid] {
            return characteristic
        }
        let characteristic = Characteristic(service: self, uuid: uuid)
        characteristics[uuid] = characteristic
        return characteristic
    }
}

public typealias PeripheralBlock = (Peripheral) -> Void

public final class Peripheral: NSObject, CBPeripheralDelegate {
    public var services: [CBUUID: Service] = [:]
    public var uuid: UUID { return core.identifier }
    public var timeoutConnect: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)
    public var timeoutDiscoverServices: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)
    public var disconnectBlock: PeripheralBlock?

    fileprivate let bluetooth: Bluetooth
    fileprivate let core: CBPeripheral

    fileprivate init(bluetooth: Bluetooth, core: CBPeripheral) {
        self.bluetooth = bluetooth
        self.core = core
        super.init()
        core.delegate = self
    }

    fileprivate let connectSignal = DispatchGroup()
    func connect() throws {
        try bluetooth.ready()
        if core.state == .connected {
            return
        }
        // connecting?
        connectSignal.enter()
        let timeout = DispatchTime.now() + timeoutConnect

        bluetooth.central.connect(core, options: nil)
        if connectSignal.wait(timeout: timeout) == .timedOut {
            ERR("connect timed out")
            throw "connect timed out"
        }
    }

    func disconnect() {
        bluetooth.central.cancelPeripheralConnection(core)
    }

    @discardableResult
    func find(service uuid: CBUUID) -> Service {
        if let service = services[uuid] {
            return service
        }
        let service = Service(peripheral: self, uuid: uuid)
        services[uuid] = service
        return service
    }

    fileprivate let discoverSignal = DispatchGroup()
    func discover() throws -> Bool {
        guard core.state == .connected else {
            ERR("not connected")
            throw "not connected"
        }

        discoverSignal.enter()
        let timeout = DispatchTime.now() + timeoutDiscoverServices
        let query = services.count == 0
            ? nil
            : Array(services.keys)
        core.discoverServices(query)

        if discoverSignal.wait(timeout: timeout) == .timedOut {
            ERR("service discovery timed out")
            throw "service discovery timed out"
        }

        var error = false
        for (_, service) in services {
            error = error || !service.isValid

            for (_, characteristic) in service.characteristics {
                error = error || !characteristic.isValid
            }
        }

        return !error
    }

    public func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        LOG("peripheralDidUpdateName")
    }

    public func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        LOG("peripheralDidUpdateRSSI")
    }

    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        LOG("didReadRSSI")
    }

    public func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        LOG("didModifyServices invalidatedServices")
        for service in invalidatedServices {
            services.removeValue(forKey: service.uuid)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        LOG("didDiscoverIncludedServicesFor service")
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // LOG("didDiscoverServices")
        if error != nil {
            ERR("p:\(peripheral.identifier.uuidString)| failed to discover services")
            // TODO: throw
        } else {
            if let core_services = peripheral.services {
                for core_service in core_services {
                    let service = find(service: core_service.uuid)
                    service.core = core_service

                    discoverSignal.enter()
                    let characteristics = service.characteristics
                    let characteristicsQuery = characteristics.count == 0
                        ? nil
                        : Array(characteristics.keys)
                    peripheral.discoverCharacteristics(characteristicsQuery, for: core_service)

                    // TODO: descriptors
                }
            }
        }
        discoverSignal.leave()
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // LOG("didDiscoverCharacteristicsFor service");
        if error != nil {
            LOG("p:\(peripheral.identifier.uuidString)| failed to discover characteristics")
            // TODO: throw
        } else {
            if let core_characteristics = service.characteristics {
                for core_characteristic in core_characteristics {
                    let characteristic = find(service: service.uuid).find(characteristic: core_characteristic.uuid)
                    characteristic.core = core_characteristic
                }
            }
        }
        discoverSignal.leave()
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        LOG("didDiscoverDescriptorsFor characteristic")
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // LOG("didUpdateValueFor characteristic: \(characteristic)")

        if let s = services[characteristic.service.uuid] {
            if let c = s.characteristics[characteristic.uuid] {
                if let core = c.core {
                    if core.isNotifying {
                        if let value = core.value {
                            if let block = c.notifyBlock {
                                block(c, value)
                            }
                        }
                        return
                    }
                } else {
                    ERR("no core")
                }

                c.readSignal.leave()
            } else {
                ERR("unknown characteristic")
            }
        } else {
            ERR("unknown service")
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        // LOG("didWriteValueFor characteristic")
        if let s = services[characteristic.service.uuid] {
            if let c = s.characteristics[characteristic.uuid] {
                c.writeSignal.leave()
            } else {
                ERR("unknown characteristic")
            }
        } else {
            ERR("unknown service")
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        LOG("didUpdateValueFor descriptor")
    }

    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        LOG("didWriteValueFor descriptor")
    }
}

public final class BluetoothDiscovery {
    public let peripheral: CBPeripheral
    public let advertisementData: [String: Any]
    public let rssi: NSNumber

    init(peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.rssi = rssi
    }

    var name: String? {
        if let localName = advertisementData["kCBAdvDataLocalName"] as? String {
            return localName
        }
        return peripheral.name
    }
}

public typealias BluetoothScanBlock = ([UUID: BluetoothDiscovery]) -> Void

public final class Bluetooth: NSObject, CBCentralManagerDelegate {
    public var timeoutReady: DispatchTimeInterval = DispatchTimeInterval.milliseconds(2000)

    fileprivate let central: CBCentralManager
    fileprivate var peripherals: [UUID: Peripheral] = [:]

    private var discoveries: [UUID: BluetoothDiscovery] = [:]
    private var discoveriesBlock: (([UUID: BluetoothDiscovery]) -> Void)?

    override init() {
        central = CBCentralManager()
        super.init()
        central.delegate = self
        readySignal.enter()
    }

    func scanStart(_ scanBlock: @escaping BluetoothScanBlock) throws {
        discoveriesBlock = scanBlock

        try ready()
        if !central.isScanning {
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func scanStop() {
        guard central.isScanning else { return }
        central.stopScan()
        discoveriesBlock = nil
    }

    func find(peripheral uuid: UUID) throws -> Peripheral? {
        try ready()
        if let peripheral = peripherals[uuid] {
            return peripheral
        } else {
            let retrieved = central.retrievePeripherals(withIdentifiers: [uuid])
            guard retrieved.count == 1 else { return nil }
            guard let core = retrieved.first else { return nil }
            let peripheral = Peripheral(bluetooth: self, core: core)
            peripherals[uuid] = peripheral
            return peripheral
        }
    }

    fileprivate let readySignal = DispatchGroup()
    fileprivate func ready() throws {
        let timeout = DispatchTime.now() + timeoutReady
        if readySignal.wait(timeout: timeout) == .timedOut {
            ERR("ready timeout out")
            throw "ready timed out"
        }

        guard central.state == .poweredOn else {
            print("bluetooth| not powered on")
            return
        }
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // LOG("state \(central.state)")
        readySignal.leave()
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // LOG("didConnect")
        guard let p = peripherals[peripheral.identifier] else {
            ERR("unknown connection")
            // TODO: throw
            return
        }
        p.connectSignal.leave()
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // LOG("didFailToConnect peripheral")

        guard let p = peripherals[peripheral.identifier] else {
            ERR("unknown peripheral")
            // TODO: throw
            return
        }
        ERR("failed to connect")
        // TODO: throw
        p.connectSignal.leave()
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // LOG("didDisconnectPeripheral")

        guard let p = peripherals[peripheral.identifier] else {
            ERR("unknown peripheral")
            // TODO: throw
            return
        }

        if let block = p.disconnectBlock {
            block(p)
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        discoveries[peripheral.identifier] = BluetoothDiscovery(
            peripheral: peripheral,
            advertisementData: advertisementData,
            rssi: RSSI
        )

        if let block = discoveriesBlock {
            block(discoveries)
        }
    }
}
