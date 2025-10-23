import habilidades.*
import wollok.game.*
import adminEnemigos.*
import administradorPlantas.*
import zombie.*
import menu.*
import adminProyectiles.administradorDeProyectiles

//Clase de creacion de plantas y sus propiedades

class Planta{
    var property position = game.origin()
    var property precio
    var property vida 
    var property esZombie = false
    
    method image() = ""

   // Métodos
  method frenarEnemigo() = true

  method esGirasol() = false
  method puedeDisparar() = false

  method sePuedeSuperponer() = false

  method valorAgregado() = 0
  
  method recibirDanio(danio) { 
    self.vida(self.vida() - danio) 
    self.matar() //Esto evalua la vida y si corresponde la elimina
  }

  method estaMuerto() {
    return self.vida() <= 0
  }

  method matar(){
    if (self.estaMuerto()) self.eliminar()
  }

  method eliminar() {
    game.removeVisual(self)
    administradorPlantas.removerPlanta(self)
  }

  method cambiarAccion(accionNueva){}
  method proyectil() = false
  method mejorar(){}

   method accion() {}
}

class PlantaQueDispara inherits Planta{
  const proyectilBase = Poroto

  override method puedeDisparar() = true

  method casillaAdelante(){
    return game.at(self.position().x() + 1,self.position().y())
  }

  method disparar(){
      administradorDeProyectiles.generarProyectil(self.casillaAdelante())
  }
} 

class Nuez inherits Planta(precio = 100, vida = 100){
  override method image() = "nuez.png"
}

class Girasol inherits Planta(precio = 50, vida = 40){
  override method image() = "girasoll.png"
  override method esGirasol() = true
  const drop = Sol
  override method accion() = drop.dropPuntos()
}   

class Lanzaguisantes inherits PlantaQueDispara(precio = 100, vida = 50){
   override method image() = "lanzaguisantes.png"
}  
 
class NuezGrande inherits Planta(precio = 75, vida = 100){
   override method image() = "nuez_grande.png"
}