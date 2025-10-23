import wollok.game.*
import plantas.*

//Consideramos Menu a todos los elementos de la primer fila, incluyendo tienda de plantas, dinero y casa (VIDA)

object casa {
  var property vidas = 3
    
  method position() = game.at(9, game.height()-1)  
  method text() = "Vidas restantes: " + vidas.toString()
  
  method textColor() = "#FA0770"

  method moriste(){
    return vidas <= 0
    }

  method textVida(){
        vidas = 0
        self.text()
    }

   method recibirDanio(danio){
        vidas = vidas - danio
    }
}



class PlantasTienda{
    //Cada instancia de esta clase va a ser una casilla de la tienda
    const position
    const costo
    const property tipoPlanta // para saber qué planta crear
    
    method position() = position
    method text() = costo.toString() + "$"
    method image() = ""
    method textColor() = "ffec00ff"
    
    // Método para crear la planta correspondiente
    method crearPlanta() {
        return tipoPlanta.apply()
    }
    
    method puedeComprar() = dinero.dineroActual() >= costo
    
    //Si el dinero actual alcanza para comprar, se compra la planta y resta dinero actual
    //devuelve puede para usarlo en adminJuego en el metodo de plantar
    method comprar() {
    const puede = self.puedeComprar()
    if (puede) dinero.restarDinero(costo)
    return puede
    }
}

object girasolTienda inherits PlantasTienda(
    position = game.at(0,game.height()), 
    costo = 50,
    tipoPlanta = { => new Girasol() }
) {
    override method image() = "GirasolTienda.png"
}

object lanzaguisantesTienda inherits PlantasTienda(
    position = game.at(1,game.height()), 
    costo = 100,
    tipoPlanta = { => new Lanzaguisantes(precio = 100, vida = 100) }
) {
    override method image() = "LanzaGuisantesTienda.png"
}

object nuezTienda inherits PlantasTienda(
    position = game.at(2,game.height()), 
    costo = 75,
    tipoPlanta = { => new Nuez() }
) {
    override method image() = "NuezTienda.png"
}

object nuezGrandeTienda inherits PlantasTienda(
    position = game.at(3,game.height()), 
    costo = 100,
    tipoPlanta = { => new NuezGrande() }
) {
    override method image() = "NuezgrandeTienda.png"
}

object dinero {
    const dineroInicial = 200

    var property dineroActual = dineroInicial

    method position() = game.at(7, game.height()-1)
    method sumarPuntos() { self.dineroActual(dineroActual + 5) }
    
    method restarDinero(costo) { 
        if (dineroActual >= costo) {
            dineroActual -= costo
        }
    }

    method text() = dineroActual.toString() + "$"
    method textColor() = "#FA0770"

    method reset() {
        dineroActual = dineroInicial
    }


    //Este metodo suma dinero si muere un zombie o por el drop de girasoles
    method sumarDinero(personajePuntos){
        self.dineroActual(dineroActual + personajePuntos)
    }
}

//Este es el menu de la tienda con su cursor:
object menu {
    var property position = game.at(0,game.height())
    method image() = imagenActual
    var property imagenActual = cursorNormal 
    const cursorNormal = "cursorRojo.png"

    var property plantaReferenciada = null
    var property modoSeleccion = false
    var property plantaSeleccionada = null //guarda la planta de la tienda seleccionada

    method agregarAPantalla(){
        game.addVisual(self)
        game.addVisual(dinero)
        game.addVisual(casa)
    }

    method configurarTeclas() {
        keyboard.a().onPressDo({ self.moverseIzquierda() })
        keyboard.d().onPressDo({ self.moverseDerecha() })
        keyboard.enter().onPressDo({ self.seleccionarPlanta() })
    }

    method setPlanta(planta) {
        plantaReferenciada = planta
    }

    method validarPosicion(nuevaPosicion) = 
        nuevaPosicion.x().between(0, 6) 

    method dirigirse(nuevaPosicion) {
        if(self.validarPosicion(nuevaPosicion)) {
            position = nuevaPosicion
        }
    }

    method moverseDerecha(){
        self.dirigirse(self.position().right(1))
    }

    method moverseIzquierda(){
        self.dirigirse(self.position().left(1))
    }

//Set con cada casillero de la tienda con plantas a comprar
    const tiendas = #{ girasolTienda, lanzaguisantesTienda, nuezTienda, nuezGrandeTienda }


//para c/elemento t del conjunto (cada tienda), quiero ver si su posición es igual a la pos actual del menu.
    method seleccionarPlanta() {
        const tienda = tiendas.findOrDefault({ t => t.position() == self.position() }, null) 
        //t.position() → devuelve la pos del objeto tienda.
        //self.position() → devuelve la pos del cursor del menu (el objeto actual). y con el == comparo, si no son iguales, devuelve null
        if (tienda != null) plantaSeleccionada = tienda
    }

    method iniciarTienda() {
        game.addVisual(girasolTienda)
        game.addVisual(lanzaguisantesTienda)
        game.addVisual(nuezTienda)
        game.addVisual(nuezGrandeTienda)
    }
}