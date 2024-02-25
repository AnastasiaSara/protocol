import UIKit

//MARK: - 1
//Реализовать структуру IOSCollection и создать в ней copy on write

func address(_ o: AnyObject) -> String {
    "\(Unmanaged.passUnretained(o).toOpaque())"
}

struct Custom {
    var name: String
}

class Ref<T> {
    var value: T
    init(value: T) {
        self.value = value
    }
}

struct Container<T> {
    var ref: Ref<T>
    
    init(value: T) {
        self.ref = Ref(value: value)
    }
    
    var value: T {
        get {
            ref.value
        }
        set {
            guard isKnownUniquelyReferenced(&ref) else {
                ref = Ref(value: newValue)
                return
            }
            ref.value = newValue
        }
    }
}

var container1 = Container(value: Custom(name: "Nastya"))
var container2 = container1
address(container1.ref)
address(container2.ref)

container2.value.name = "empty"

address(container1.ref)
address(container2.ref)


//MARK: - 2
//Создать протокол *Hotel* с инициализатором, который принимает roomCount, после создать class HotelAlfa добавить свойство roomCount и подписаться на этот протокол
protocol Hotel {
    
    var roomCount: Int { get set }
}


class HotelAlfa: Hotel {
    
    var roomCount: Int
    
    init(roomCount: Int) {
        self.roomCount = roomCount
    }
}

let hotel = HotelAlfa(roomCount: 3)
hotel.roomCount


//MARK: - 3
//Создать protocol GameDice у него {get} свойство numberDice далее нужно расширить Int так, чтобы когда мы напишем такую конструкцию 'let diceCoub = 4 diceCoub.numberDice' в консоле мы увидели такую строку - 'Выпало 4 на кубике'


protocol GameDice {
    
    var numberDice: String { get }
}

extension Int: GameDice {
    
    var numberDice: String {
        "Выпало \(self) на кубике"
    }
}

let diceCoub = Int.random(in: 1...6)
print(diceCoub.numberDice)


//MARK: - 4
//Создать протокол с одним методом и 2 свойствами одно из них сделать явно optional, создать класс, подписать на протокол и реализовать только 1 обязательное свойство

@objc protocol Phone {
    
    @objc optional var number: String { get }
    var color: String { get }
    
    func call(color: String) -> String
}

class SomePhone: Phone {
    var color: String = "black"
    
    func call(color: String) -> String {
        "An number called you from a \(color) phone"
    }
}

let phone = SomePhone()
print(phone.call(color: "black"))


//MARK: - 5
/*Создать 2 протокола: со свойствами время, количество кода и функцией writeCode(platform: Platform, numberOfSpecialist: Int); и другой с функцией: stopCoding(). Создайте класс: Компания, у которого есть свойства - количество программистов, специализации(ios, android, web)
 Компании подключаем два этих протокола
 Задача: вывести в консоль сообщения - 'разработка началась. пишем код <такой-то>' и 'работа закончена. Сдаю в тестирование', попробуйте обработать крайние случаи.
*/
protocol Coding {
    
    var time: Int { get }
    var countCode: Int { get }
    
    func writeCode(platform: String, numberOfSpecialist: Int)
}

protocol StopCode {
    
    func stopCoding()
}


class Compony: Coding, StopCode {
    
    var numberOfSpecialist: Int
    var platform: [String]
    var time: Int
    var countCode: Int
    
    init(numberOfSpecialist: Int, platform: String, time: Int, countCode: Int) {
        self.numberOfSpecialist = numberOfSpecialist
        self.platform = ["ios", "android", "web"]
        self.time = time
        self.countCode = countCode
    }
    
    func writeCode(platform: String, numberOfSpecialist: Int) {
        print("С начала разработки прошло \(time) дней.\nНаписано \(countCode) строчек кода.\nНад проектом под \(platform) технологии задействовано \(numberOfSpecialist) специалистов.")
    }
    
    func stopCoding() {
        print("Работа закончена. Сдаю в тестирование")
        time = 0
    }
}



let development = Compony(numberOfSpecialist: 21, platform: "ios", time: 32, countCode: 47)
development.writeCode(platform: "ios", numberOfSpecialist: 16)
development.stopCoding()
development.time
