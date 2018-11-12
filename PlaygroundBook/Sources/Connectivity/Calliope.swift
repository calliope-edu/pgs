import CoreBluetooth
import Foundation

public enum CalliopeImage: Int16 {
    case smiley = 0x00
    case sad = 0x01
    case heart = 0x02
    case arrow_left = 0x03
    case arrow_right = 0x04
    case arrow_left_right = 0x05
    case full = 0x06
    case dot = 0x07
    case small_rect = 0x08
    case large_rect = 0x09
    case double_row = 0x0a
    case tick = 0x0b
    case rock = 0x0c
    case scissors = 0x0d
    case well = 0x0e
    case flash = 0x0f
    case wave = 0x10
}

public final class Calliope {
    private let debug = false
    private static let ble = Bluetooth()

    private static let uuid_service_debug =
        CBUUID(string: "FF44DDEE-251D-470A-A062-FA1922DFA9A8")
    private static let uuid_characteristic_debug =
        CBUUID(string: "FF44DDEE-251D-470A-A062-FA1922DFA9A8")

    private static let uuid_service_notify =
        CBUUID(string: "FF55DDEE-251D-470A-A062-FA1922DFA9A8")
    private static let uuid_characteristic_notify =
        CBUUID(string: "FF55DDEE-251D-470A-A062-FA1922DFA9A8")

    private static let uuid_service_program =
        CBUUID(string: "FF66DDEE-251D-470A-A062-FA1922DFA9A8")
    private static let uuid_characteristic_program =
        CBUUID(string: "FF66DDEE-251D-470A-A062-FA1922DFA9A8")

    public let uuid: UUID
    public var onDisconnect: ((Calliope) -> Void)?
    public var onNotify: ((Calliope, Data) -> Void)?

    private var peripheral: Peripheral?
    private var serviceUpload: Service?
    private var characteristicUpload: Characteristic?

    init(uuid: UUID) {
        self.uuid = uuid
    }

    public static func scanStart(_ scanBlock: @escaping BluetoothScanBlock) throws {
        try ble.scanStart({ discoveries in
            let calliopes = discoveries.filter({ (_, discovery) -> Bool in
                discovery.name?.hasPrefix("BBC micro:bit [") ?? false
                    || discovery.name?.hasPrefix("Calliope mini [") ?? false
            })
            scanBlock(calliopes)
        })
    }

    public static func scanStop() {
        ble.scanStop()
    }

    public func connect() throws {
        if let peripheral = try Calliope.ble.find(peripheral: uuid) {
//            let service_debug = peripheral.find(service: Calliope.uuid_service_debug)
//            let characteristic_debug = service_debug.find(characteristic: Calliope.uuid_characteristic_debug)

            let service_program = peripheral.find(service: Calliope.uuid_service_program)
            let characteristic_program = service_program.find(characteristic: Calliope.uuid_characteristic_program)

            let service_notify = peripheral.find(service: Calliope.uuid_service_notify)
            let characteristic_notify = service_notify.find(characteristic: Calliope.uuid_characteristic_notify)

            try peripheral.connect()

            peripheral.disconnectBlock = { [weak self] _ in
                if let me = self, let block = me.onDisconnect {
                    block(me)
                }
            }

            characteristic_notify.notifyBlock = { [weak self] _, data in
                if let me = self, let block = me.onNotify {
                    block(me, data)
                }
            }

            if try peripheral.discover() {
                // found all required services and characteristics
                self.peripheral = peripheral
            } else {
                throw "did not find all required services and characteristics"
            }

            try characteristic_notify.setNotify(enabled: true)

            if debug {
                LOG("status \(try characteristic_program.read().hexEncodedString())")
                //try dump(characteristic_debug);
            }

        } else {
            throw "did not find peripheral"
        }
    }

    private func dump(_ characteristic: Characteristic) throws {
        LOG("buffer:")
        for a in stride(from: 0, to: 12 * 16, by: 16) {
            let type = UInt8(0x00)
            let hi = UInt8(0xff & (a >> 8))
            let lo = UInt8(0xff & a)
            let req = Data(bytes: [type, hi, lo])
            try characteristic.write(data: req)
            let res = try characteristic.read()
            var hex = res.hexEncodedString()
            hex.insert(" ", at: hex.index(hex.startIndex, offsetBy: 6))
            hex.insert(" ", at: hex.index(hex.startIndex, offsetBy: 2))
            LOG("\(hex)")
        }
        LOG("methods:")
        for a in stride(from: 0, to: 5 * 2, by: 2) {
            let type = UInt8(0x01)
            let hi = UInt8(0xff & (a >> 8))
            let lo = UInt8(0xff & a)
            let req = Data(bytes: [type, hi, lo])
            try characteristic.write(data: req)
            let res = try characteristic.read()
            var hex = res.hexEncodedString()
            hex.insert(" ", at: hex.index(hex.startIndex, offsetBy: 6))
            hex.insert(" ", at: hex.index(hex.startIndex, offsetBy: 2))
            LOG("\(hex)")
        }
    }

    public func disconnect() {
        if let peripheral = self.peripheral {
            peripheral.disconnect()
        }
    }

    private func hash(bytes: [UInt8]) -> UInt16 {
        return 0
    }

    private func partition(data: Data, size: Int, _ block: @escaping (Data) throws -> Void) throws {
        try data.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
            let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
            let totalSize = data.count
            var chunkOffset = 0
            while chunkOffset < totalSize {
                let chunkSize = chunkOffset + size > totalSize ? totalSize - chunkOffset : size
                let chunkData = Data(bytesNoCopy: mutRawPointer + chunkOffset, count: chunkSize, deallocator: Data.Deallocator.none)
                try block(chunkData)
                chunkOffset += chunkSize
            }
        }
    }

    public func upload(program: ProgramBuildResult) throws {
        let code = program.code
        let methods = program.methods

        guard let peripheral = self.peripheral else { throw "no connected peripheral" }

        let mtu = 16

        let service_link = peripheral.find(service: Calliope.uuid_service_program)
        let characteristic_link = service_link.find(characteristic: Calliope.uuid_characteristic_program)

//        let service_debug = peripheral.find(service: Calliope.uuid_service_debug)
//        let characteristic_debug = service_debug.find(characteristic: Calliope.uuid_characteristic_debug)

        let status = try characteristic_link.read()

        if debug {
            LOG("status before \(status.hexEncodedString())")
        }

        // TODO: check version and size

        // transfer code in parts
        var address: Int = 0
        try partition(data: Data(bytes: code), size: mtu) { part in
            let len = part.count
            var packet = Data(bytes: [
                len.hi(), len.lo(),
                address.hi(), address.lo(),
            ])
            packet.append(part)

            LOG(String(format: "packet address:%.4x len:%.4x", address, len))

            try characteristic_link.write(data: packet)
            address += len
        }

        if debug {
            LOG("status stage1 \(try characteristic_link.read().hexEncodedString())")
        }

        // transfer end packet
        let hash_is = hash(bytes: code)
        var packet = Data(bytes: [
            0x00, 0x00, // len = 0
            hash_is.hi(), hash_is.lo(),
        ])
        for method in methods {
            packet.append(method.hi())
            packet.append(method.lo())
        }
        try characteristic_link.write(data: packet)

        if debug {
            LOG("status stage2 \(try characteristic_link.read().hexEncodedString())")
            //try dump(characteristic_debug)
        }
    }
}


extension Calliope: CustomStringConvertible {
    public var description: String {
        return uuid.description
    }
}
