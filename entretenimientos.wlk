class Entrada {
    var property banda
    var property fecha
    var property precioBase
    var property precioConDescuento

    method precioAlPublico() = precioBase + productora.impuesto()
}

object productora {
   var property impuesto = 3000
   const property bandas = []
   const property asistentes = []

   method gananciaTotal() {
    return self.totalRecaudado() - self.presupuestoBandas()
   }

   method totalRecaudado() {
    return asistentes.sum({unAsistente => unAsistente.totalGastadoEntradas()})
   }

   method presupuestoBandas() {
    return bandas.sum({unaBanda => unaBanda.presupuesto()})
   }

    method cantEntradasVendidas() {
        return asistentes.sum({unaAsistente => unaAsistente.cantEntradas()})
    }

    method bandaMasPopular() {
        return bandas.max({unaBanda => unaBanda.popularidad()})
    }

}

class Asistente {

    var property historialEntradas = []
    var property  abono 
    var property dineroDisponible


    method totalGastadoEntradas() {
        return historialEntradas.sum({unaEntrada => unaEntrada.precioConDescuento()})
    }

    method comprarEntrada( unaEntrada) {
        self.validarSaldo()
        self.comprar(unaEntrada)

    }

    method validarSaldo() {
        if (dineroDisponible < 0) {
            throw new SaldoNegativo(message = "no puede comprar la entrada")
        }
    }

    method comprar(unaEntrada) {
        var precioFinal = abono.precioConDescuento(unaEntrada.precioAlPublico())
        dineroDisponible -= precioFinal
        unaEntrada.precioConDescuento(precioFinal)
        historialEntradas.add(unaEntrada)
    }

    method nombreBandas() {
        return historialEntradas.map({unaEntrada => unaEntrada.nombre()}).asSet()
    }

    method cantEntradas() = historialEntradas.size()

    method bonificar() {
        abono.incrementarDescuento(1)
    }
}

  class SaldoNegativo inherits DomainException() {}



class Banda {
    var property  nombre 
    var property canon =  1000000

    method presupuesto() {
        return canon + self.gastoExtra()
    }

    method gastoExtra()

    method popularidad()
}


class Rock inherits Banda {
    var property cantSolos
    override method gastoExtra() = 10000

    override method  popularidad()   = 100 * cantSolos
      
    }

class Trap inherits Banda {
    var property  tieneHielo
    override method gastoExtra() = 0

    override method  popularidad() {
    if (tieneHielo) {
        return 1000
    }
    return 0
 }
}

class Indie inherits Banda {
    var property cantInstrumentos

    override method popularidad() = 3.14 * nombre.size()

    override method gastoExtra() = 500 * cantInstrumentos
}

object fan {

    method precioConDescuento(_) = 0
    method incrementarDescuento(_) {}
}

class Vip {
    var property descuento 

    method precioConDescuento(unPrecio) = unPrecio * descuento /100
    method incrementarDescuento(cant) {
        descuento += cant
    }
}