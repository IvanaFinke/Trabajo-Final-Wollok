import wollok.game.*

//Archivo del menu principal de eleccion de niveles del juego
object menuNiveles {
    var property nivelSeleccionado = 1
    var property visible = true
    
    method position() = game.at(0, 0)
    method image() = "menu2.png"
    
    method mostrar() {
        visible = true
        game.addVisual(self)
    }
    
    method ocultar() {
        visible = false
        game.removeVisual(self)
    }
    
    method configurarTeclas() {
        keyboard.num1().onPressDo({ self.seleccionarNivel(1) })
        keyboard.num2().onPressDo({ self.seleccionarNivel(2) })
        keyboard.num3().onPressDo({ self.seleccionarNivel(3) })
        keyboard.num4().onPressDo({game.stop()})
    }
    
    method seleccionarNivel(nivel) {
        if (visible) {
            nivelSeleccionado = nivel
            self.ocultar()
        }
    }
}

// El fondo del juego como un visual más
object fondoJuego {
    method position() = game.at(0, 0)
    method image() = "Fondo.png"
    method frenarEnemigo() = false
}