import zombie.*
import adminEnemigos.*

//EL ADMIN DE OLEADAS SE ENCARGA DE MANEJAR LAS OLEADAS DE ENEMIGOS QUE SON MANEJADAS CON UN ARRAY

//DESDE ADMIN OLEADAS VA A IMPORTAR EÑ ADMINISTRADOR DE ENEMIGOS Y A VA A TRAER A TODOS LOS ENEMIGOS
//DE ESE ARRAY PARA QUE LOS GENERE CADA X TIEMPO SEGUN CORRESPONDA
object administradorDeOleadas {
    var nivelActual = nivel1 //Nivel por defecto, puede sacarse

    var property numeroOleada = 1
    var property modoInfinito = false

    var property indiceOleada = 0 //Indice para seleccionar oleadas

    method oleadas(){return nivelActual.oleadas()}  //Devuelve las oleadas del nivel actual

    method obtenerOleada(){return self.oleadas().get(indiceOleada)} //Devulve un array de enemigos

    method proximaOleada(){indiceOleada = indiceOleada + 1} //Avanza a la siguiente oleada del array

    //Si esta dentro del tamaño de oleadas van a spawnear los enemigos segun cada oleada y avanza indice
    method spawnearOleada(){
        if(indiceOleada < self.cantidadOleadas()){
            console.println("Indice Actual")
            console.println(self.indiceOleada())

            console.println("Oleada Actual")
            console.println(self.obtenerOleada())

        //Va a spawnear todos los enemigos del array de oleada actual
            self.obtenerOleada().forEach({z => administradorDeEnemigos.spawnear(z)})
            //Avanza a siguiente oleada
            self.proximaOleada()
            console.println("SPAWNEARONNN!!!!!")
            console.println("Zombies actuales")
            console.println(administradorDeEnemigos.zombies())
            console.println("----------------------")
        }
    }
    method cantidadOleadas(){return nivelActual.oleadas().size()}

    //Periodo de aparicion de enemigos entre oleadas
    method tiempoSpawn(){return nivelActual.tiempoSpawn()}
        
    //cosas para funcionamiento con niveles
    var property numNivel = 1
 
    // Métodos de visualización y sonido
    method position() = game.at(9,5)
    method text() = "Oleada: " +  numeroOleada.toString() + "     Nivel: " + nivelActual.nombre().toString()  + "     " + "Zombies Restantes: " + nivelActual.enemigosRestantes().toString()
    method textColor() = "#FA0770"
    method enemigosVivos() = nivelActual.enemigosVivos()

    const tickParaGenerarEnemigos=game.tick(nivelActual.tiempoSpawn(),{self.spawnearOleada()},false)

    // Gestión de contadores de enemigos
    method reducirEnemigo() { nivelActual.seMurioEnemigo()}
    method sumarEnemigo() { nivelActual.seGeneroEnemigo() }

    // Resetea el administrador de oleadas
    method reset() {
        tickParaGenerarEnemigos.stop()
        nivelActual.reset()
        nivelActual.resetearCantEnemigosComoAlInicio()
        numeroOleada = 1
    }

    method frenarEnemigo()= true
}

class Nivel{
    //Cada nivel va a tener un array de oleadas
    //Cada oleada es un grupo de enemigos que spawnea en simultaneo o cada un delta T
    //Cuando mueren  todos los enemigos de una oleada o pasa X tiempo aparece la siguiente oleada

    const property oleadas //Array de arrays de enemigos, cada array de adentro es un grupo de enemigo
    const property tiempoSpawn
    const property nombre
}

//INSTANCIAS DE NIVELES
const zombieBalde1 = new ZombieBalde()
const zombieBalde2 = new ZombieBalde()
const zombieBalde3 = new ZombieBalde()
const zombieBalde4 = new ZombieBalde()
const zombieBalde5 = new ZombieBalde()
const zombieBalde6 = new ZombieBalde()
const zombieBalde7 = new ZombieBalde()
const zombieBalde8 = new ZombieBalde()
const zombieBalde9 = new ZombieBalde()
const zombieBalde10 = new ZombieBalde()

const zombieCono1 = new ZombieCono()
const zombieCono2 = new ZombieCono()
const zombieCono3 = new ZombieCono()
const zombieCono4 = new ZombieCono()
const zombieCono5 = new ZombieCono()
const zombieCono6 = new ZombieCono()
const zombieCono7 = new ZombieCono()
const zombieCono8 = new ZombieCono()
const zombieCono9 = new ZombieCono()
const zombieCono10 = new ZombieCono()

const zombieNormal1 = new ZombieNormal()
const zombieNormal2 = new ZombieNormal()
const zombieNormal3 = new ZombieNormal()
const zombieNormal4 = new ZombieNormal()
const zombieNormal5 = new ZombieNormal()
const zombieNormal6 = new ZombieNormal()

//Instancias de niveles:
const nivel1 = new Nivel(oleadas = [[zombieNormal1,zombieCono1, zombieBalde1],
                        [zombieCono2, zombieBalde2],
                        [zombieBalde3,zombieCono4],
                        [zombieBalde4,zombieNormal2,zombieNormal3],
                        [zombieBalde5,zombieCono3]], tiempoSpawn=10000, nombre="Nivel 1")

const nivel2 = new Nivel(oleadas = [
                        [zombieCono1,zombieBalde1],
                        [zombieNormal1,zombieCono2,zombieBalde2],
                        [zombieBalde3,zombieCono3],
                        [zombieNormal2,zombieBalde4,zombieCono4],
                        [zombieCono5,zombieBalde5],
                        [zombieNormal3,zombieCono6,zombieBalde6],
                        [zombieCono7,zombieCono8,zombieNormal4]],tiempoSpawn = 8000,nombre = "Nivel 2")

 const nivel3 = new Nivel(oleadas = [[zombieCono1,zombieBalde1],
                        [zombieNormal1,zombieBalde2,zombieCono2],
                        [zombieBalde3,zombieCono3],
                        [zombieNormal2,zombieCono4,zombieBalde4],
                        [zombieBalde5,zombieCono5],
                        [zombieNormal3,zombieBalde6,zombieCono6],
                        [zombieBalde7,zombieCono7,zombieNormal4],
                        [zombieCono8,zombieBalde8],
                        [zombieNormal5,zombieCono9,zombieBalde9]],tiempoSpawn = 6000,nombre = "Nivel 3")

