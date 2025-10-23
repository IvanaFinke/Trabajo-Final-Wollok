import wollok.game.*
import adminProyectiles.*
import adminEnemigos.*

class Proyectil{

    var property position = game.origin()
    var property proyectil = Poroto
    
    method poder() = 10
    method image() = "proyectil.png"    
    method frenarEnemigo() = false
    method sePuedeSuperponer() = true
     var property esZombie = false

     // Método de movimiento
    method avanzar() {
        position = self.position().right(1)
    }

    method llegoAlFinal() = position.x() >= game.width() - 1

    // Método de colisión, si el proyectil se encuentra con un zombie en su misma posicion
    //El zombie recibira daño y se elimina el visual de proyectil
    method colisionar() {
    const objetosEnMiCelda = game.getObjectsIn(self.position())
    objetosEnMiCelda.forEach({ objeto =>
        if (objeto.esZombie()) {
            objeto.recibirDanio(self.poder())
            administradorDeProyectiles.removerProyectil(self)
        }
        })
    } 
}

class Poroto inherits Proyectil(){
    override method poder() = 20 
}

class Sol{
    const property dropPuntos = 25
    var property position = game.origin()
    method image() = "Sol2.png"
    var property esZombie = false
}


