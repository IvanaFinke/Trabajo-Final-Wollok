import adminProyectiles.*
import plantas.*
import game.*
import zombie.*
import menu.dinero

/* =======================================
   Administrador de Enemigos: Gestión de enemigos en el juego
   ======================================= */
object administradorDeEnemigos {
 
  const property zombies = #{}  

    method avanzar(){
        zombies.forEach({z => z.avanzar()})
    }

    method atacar(){
        zombies.forEach({z => z.atacar()})
    }

    //INICIO SPAWN ZOMBIES
    method posicionSpawn() {
        const x = game.width() - 1
        const y = 0.randomUpTo(game.height()-1).truncate(0)
        return game.at(x, y)      
        }
    
    //Metodo creado para que no spawneen dos zombies en la misma casilla
    method hayZombieEn(pos){ 
        return zombies.any({z => z.position() == pos})
    }

    method spawnear(zombie){
        //Revisa que la posicion elegida no esté ocupada por otro zombie
        const posSpawn = self.posicionSpawn()
        if(!self.hayZombieEn(posSpawn)){
            zombie.position(posSpawn) 
            zombies.add(zombie)
            game.addVisual(zombie)    
        }
        else{console.println("No se pudo spawnear porque la casilla esta ocupada")}
    }

    //Elimina al zombie y suma sus puntos de dinero
    method eliminarZombie(zombie){
        self.zombies().remove(zombie)
        zombie.eliminar() // Este metodo elimina la visual
        dinero.sumarDinero(zombie.puntosAlMorir())
    }

    method eliminarZombies(){
        zombies.forEach({z => self.eliminarZombie(z)})
    }

    method eliminarZombies(zombiesFunc){
        zombiesFunc.forEach({z => self.eliminarZombie(z)})
    }

    //Verificacion de cuantos zombies llegan a la casa y eliminacion de los mismos
    //para que cada zombie quite unicamente una vida y no saque una por cada tick 
    //parado en la celda
    method ProcesarZombiesSiLlegaronACasa() {
        //ME filtro los que llegaron
        return self.zombies().filter({ z => z.llegoACasa() })
    }
}


