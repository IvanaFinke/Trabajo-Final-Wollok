import wollok.game.*
import plantas.*
import habilidades.*
import menu.*
import adminProyectiles.*

object administradorPlantas {
  var property plantas = #{}
  var property soles = #{}

  method añadirPlanta(p) { plantas.add(p) }
  method removerPlanta(p)   { plantas.remove(p) }

  method plantarEn(pos, planta){
    planta.position(pos)
    game.addVisual(planta)
    self.añadirPlanta(planta)
  }

  //Restaura las colecciones a estado original y resetea visuales
  method reset() {
        plantas.clear()
        soles.forEach({ sol => game.removeVisual(sol) })
        soles.clear()
  }

  //Comprueba si hay algun girasol en el mapa
  method hayGirasol() = plantas.any({ planta => planta.image() == "Girasol2.png" })

   // Genera un sol por cada girasol (llamado por el tick del administradorDeJuego)
  method generarSolesDeGirasoles() {
    // por cada planta que sea girasol: crear un Sol y mostrarlo
    plantas.forEach({ planta => if (planta.esGirasol()) {self.crearSolPara(planta)}})
  }

  // Crea un sol junto al girasol, lo muestra y programa su recolección automática
  method crearSolPara(planta) {
  const sol = new Sol()
  // posición X al lado derecho si cabe, sino a la izquierda
  var x
  if (planta.position().x() < game.width() - 1) {
    x = planta.position().x() + 1
  } else {
    x = planta.position().x() - 1
  }
  const y = planta.position().y()

  // asignar posición usando la property (setter)
  sol.position(game.at(x, y))
  game.addVisual(sol)
  soles.add(sol)

  // id único
  const uniqueId = "recolectarSol_" + x.toString() + "_" + y.toString() + "_" + (0.randomUpTo(100000)).toString()

  // Muestra los soles por 2 segundos y se borran
  game.schedule(4000,{ =>
    if (soles.any({ s => s == sol })) {
      dinero.sumarDinero(sol.dropPuntos()) // sumar usando la property del sol
      game.removeVisual(sol)
      soles.remove(sol)
    }
  })
  }

    // método auxiliar para eliminar todos los soles actuales
  method eliminarSoles() {
    soles.forEach({ s => game.removeVisual(s) })
    soles.clear()
  }

  //Consigue las plantas que disparan
  method plantasQueDisparan(){
    return plantas.filter({planta => planta.puedeDisparar()})
  }

  method disparar(){
    if (self.plantasQueDisparan().size() > 0){
      self.plantasQueDisparan().forEach({planta => planta.disparar()})
      }

  }


}