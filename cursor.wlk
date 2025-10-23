import wollok.game.*
import plantas.*

object cursor
{
    var property position = game.center()
    method image() = imagenActual
    var property imagenActual = cursorNormal 
    var property esZombie = false
    method frenarEnemigo() = false

    const cursorNormal = "cursorNegro.png"
    const cursorChico = "cursor_chico_seleccion.png"
    var property plantaReferenciada = null
    var property modoSeleccion = false

    method agregarAPantalla(){
        game.addVisual(self)
    }
    
    method configurarTeclas() {
		keyboard.left().onPressDo({ self.moverseIzquierda() })
		keyboard.right().onPressDo({ self.moverseDerecha() })
		keyboard.up().onPressDo({ self.moverseArriba()  })
		keyboard.down().onPressDo({ self.moverseAbajo() })
	}

     // asignar la planta desde el 'program juego'
    method setPlanta(planta) 
    {
        plantaReferenciada = planta
    }

  //Posicion del cursor para no moverse fuera de la pantalla o dentro del menu de tienda
   	method validarPosicion(nuevaPosicion) =  nuevaPosicion.x().between(0, game.width() - 1) and nuevaPosicion.y().between(0, game.height() - 2)

    method dirigirse(nuevaPosicion)
    {
        if(self.validarPosicion(nuevaPosicion))
        {
            position = nuevaPosicion
        }
    }
   
  method moverseDerecha(){
    self.dirigirse(self.position().right(1))
  }

  method moverseIzquierda(){
    self.dirigirse(self.position().left(1))
  }

  method moverseArriba(){
    self.dirigirse(self.position().up(1))
  }

  method moverseAbajo(){
    self.dirigirse(self.position().down(1))
  }
   
  method cambiarACursorChico(){
    modoSeleccion = true
    imagenActual = cursorChico

    // remover cualquier timer anterior
    game.removeTickEvent("restaurarCursor")

    // restaurar a normal después de 250 ms y salir de modo selección
    game.onTick(250, "restaurarCursor", { =>
      modoSeleccion = false
      imagenActual = cursorNormal
      game.removeTickEvent("restaurarCursor")
    })
  }
}