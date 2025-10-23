import wollok.game.*
import plantas.*
import cursor.*
import menu.*
import administradorPlantas.administradorPlantas
import adminEnemigos.administradorDeEnemigos
import adminProyectiles.administradorDeProyectiles
import adminOleadas.*

object administradorDeJuego {

    method configurarTeclas(){
        cursor.configurarTeclas()
        menu.configurarTeclas()
        keyboard.enter().onPressDo({self.plantar()})
    }

    method crearTicks(){
        self.iniciarSolesAutomatica()
        self.iniciarZombies()
        self.iniciarProyectiles()
        self.iniciarPlantas()
    }

    method agregarInterfazJuego(){
        menu.agregarAPantalla()
        cursor.agregarAPantalla()
    }

//Planta si el cursor no se paso de los limites de pantalla y si no hay una planta en esa ubicacion
    method plantar(){
    const pos = cursor.position()
    
    if (pos.y() != game.height() - 1 && 
        menu.plantaSeleccionada() != null && 
        !self.hayPlantaEn(pos) && 
        pos.x() <= 8) 
        {

        if (menu.plantaSeleccionada().comprar()) {
            const planta = menu.plantaSeleccionada().crearPlanta()
            administradorPlantas.plantarEn(pos, planta)
        }
        }
    }

//Verifica si no hay planta para usar en Plantar
    method hayPlantaEn(pos) {
        return administradorPlantas.plantas().any({ planta => 
            planta.position().x() == pos.x() && planta.position().y() == pos.y()
        })
    }

    //Tick para que cada 5 segundos cada girasol genere un sol
    method iniciarSolesAutomatica() {
        game.removeTickEvent("generarSolesPorGirasol")
        game.onTick(5000, "generarSolesPorGirasol", { => administradorPlantas.generarSolesDeGirasoles() })
    }

//Si hay una planta en una posicion delante zombie el zombie deja de avanzar y cambia a estado atacar
    method revisarColisionesZombies(){
        administradorDeEnemigos.zombies().forEach({
        z =>
        const siguienteCeldaZombieActual = z.celdaAdelante()
        if (self.hayPlantaEn(siguienteCeldaZombieActual)){
            z.estado(0)
        }
        else{z.estado(1)}
        })
    }

method validarSiLlegaronZombies() {
    // Pedimos la lista de zombies que llegaron (si hay)
    const zombiesQueLlegaron = administradorDeEnemigos.ProcesarZombiesSiLlegaronACasa() 

    if (!zombiesQueLlegaron.isEmpty()) {
        const cantidad = zombiesQueLlegaron.size()

        // PRIMERO eliminamos los zombies para que no se procesen dos veces
        administradorDeEnemigos.eliminarZombies(zombiesQueLlegaron)

        // DESPUÉS restamos vida
        casa.recibirDanio(cantidad)

        // Si la casa quedó sin vidas, terminamos el juego
        if (casa.moriste()) {
            casa.textVida()
            //game.stop()
            game.onTick(100, "detenerTrasMostrarVidas", { =>
                game.removeTickEvent("detenerTrasMostrarVidas")
                self.terminarPartida()
            }) //agregamos un delay chiquito porque si terminaba muy rapido no llega a ponerse en 0 las vidassx

        }
    }
}

    //Restaurar valores
    method terminarPartida(){
        administradorDeProyectiles.removerProyectiles()
        administradorDeEnemigos.eliminarZombies()
        game.stop()
    }

    method iniciarZombies(){
        game.onTick(5000, "activarColisionesZombies", { => self.revisarColisionesZombies() }) //Lo igualamos a la velocidad de avance 
        game.onTick(5000, "AvanzarZombies", { => administradorDeEnemigos.avanzar() })
        game.onTick(1000, "AtacarZombies", { => administradorDeEnemigos.atacar() })
        game.onTick(5000, "ProcesarZombiesSiLlegaronACasa", { => self.validarSiLlegaronZombies() })
    }

    method iniciarProyectiles(){
        game.onTick(1000, "iniciarProyectiles", { => administradorDeProyectiles.avanzar() })
        game.onTick(1000, "ColisionesProyectiles",{ => administradorDeProyectiles.cuandoProyectilColisionaZombie()})
    }

    method iniciarPlantas(){
        game.onTick(3000, "iniciarPlantasQueDisparan", { => administradorPlantas.disparar() })
    }

    method iniciarOleada(){
        game.onTick(administradorDeOleadas.tiempoSpawn(), "IniciarOleadasZombies", { => administradorDeOleadas.spawnearOleada() })
    }
}