// ===============================
import wollok.game.*
import adminEnemigos.*

// ===============================
// Clase Base: Zombie
// ===============================

class Zombi {
    var property position = game.origin() //Dejamos una posicion por defecto para que se puedan instanciar sin pasarla como parametro
    const property danio = 10
    var property vida = 30
    var property esZombie = true
    //Estado 1 = Avanzar    -   Estado 0 = Atacar
    var property estado = 1
    method image() = ""
    var property puntosAlMorir = 25

    method celdaAdelante(){
        return game.at(self.position().x()-1,self.position().y())
    }

    method avanzar(){ //Se mueven una casilla a la izquierda
        if (self.estado() == 1){
        position= self.position().left(1)
        }
    }

    method atacar(){
        if(self.estado() == 0){
        //Obtiene el objeto de la celda de adelante al zombie, Si es una planta va a saber responder a frenarEnemigo()
        const plantaAAtacar = game.getObjectsIn(self.celdaAdelante()).find({ planta => planta.frenarEnemigo() }) 
        //Este metodo solo se activa cuando adminJuego detecta que el zombie tiene una planta adelante por lo que no falla
        plantaAAtacar.recibirDanio(self.danio())
        }
    } 

    method eliminar() {
        game.removeVisual(self)    
    }

    method llegoACasa(){
        return self.position().x() <= 0
    }

    method compruebaVida() = self.vida() > 0

    method estaMuerto(){
        administradorDeEnemigos.eliminarZombie(self)
    }

//Recibe daño del enemigo y si la vida bajo a cero se elimina el zombie
    method recibirDanio(danioEnemigo){
        if(self.compruebaVida()){
             self.vida(self.vida()- danioEnemigo)
        }
        else{
            self.estaMuerto()
        }
       
    }
}

class ZombieBalde inherits Zombi(vida = 160) {
    override method image() = "ZombieBalde.png"}

class ZombieCono inherits Zombi(vida = 100) {
    override method image() = "ZombieCono.png"}

class  ZombieNormal inherits Zombi(vida = 80) {
    override method image() = "ZombieNormal.png"
}



