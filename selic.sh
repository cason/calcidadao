#!/bin/bash

URL="https://www3.bcb.gov.br/CALCIDADAO/publico/corrigirPelaSelic.do?method=corrigirPelaSelic"

valorCorrecao="$1"
if [ -z "$valorCorrecao" ] ; then
	valorCorrecao="1000,00"
fi
URL="${URL}&valorCorrecao=$valorCorrecao"

dataInicial="$2"
if [ -z "$dataInicial" ] ; then
	dataInicial="01/01/$(date +%Y)" # first day of the year
fi
URL="${URL}&dataInicial=$dataInicial"

dataFinal="$3"
if [ -z "$dataFinal" ] ; then
	dataFinal="$(date +%d/%m/%Y)"	# today
fi
URL="${URL}&dataFinal=$dataFinal"

links2 -dump "$URL"
