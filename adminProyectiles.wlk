import game.*
import habilidades.*

// ===============================
// Administrador de Proyectiles: Controla la creación y gestión de proyectiles
// ===============================

object administradorDeProyectiles {
  var property proyectiles = #{}  // conjunto de proyectiles

    // Genera un proyectil del tipo 'Poroto' en la posición pos y agrega al array de proyectiles
  method generarProyectil(pos) {
    const p = new Poroto()
    p.position(pos)
    // si la clase tiene image() heredada, game.addVisual la mostrará
    game.addVisual(p)
    proyectiles.add(p)
  }
  //Si los proyectiles no llegaron al final de la pantalla avanzan
  method avanzar(){
    if(self.hayProyectilEnFinal()){
        self.proyectilesQueLlegaronAlFinal().forEach({proyectil => self.removerProyectil(proyectil)})
    }
    proyectiles.forEach({proyectil => proyectil.avanzar()})
  }

  method proyectilesQueLlegaronAlFinal(){
      return proyectiles.filter({proyectil => proyectil.llegoAlFinal()})
  }

  method removerProyectil(p){
    proyectiles.remove(p)
    game.removeVisual(p)
  } 

  method removerProyectiles(){ //Metodo para limpiar pantalla
    proyectiles.forEach({p => self.removerProyectil(p)})
  }

  method hayProyectilEnFinal(){
      return !self.proyectilesQueLlegaronAlFinal().isEmpty()        
  }

//Se fija que todos los proyectiles colisionen
  method cuandoProyectilColisionaZombie(){
    proyectiles.forEach({proyectil => proyectil.colisionar()})
  }
}