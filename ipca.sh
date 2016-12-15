#!/bin/bash

URL="https://www3.bcb.gov.br/CALCIDADAO/publico/corrigirPorIndice.do?method=corrigirPorIndice"

valorCorrecao="1000,00"
dataFinal="$(date +%m/%Y -d '-1month')"	# last month
dataInicial="01/$(date +%Y)" # first month of the year
selIndice="00433IPC-A" # IPC-A (IBGE) - a partir de 01/1980

usage() {
	echo -en "Usage: $0"
	echo -en " [-v valorCorrecao=$valorCorrecao]"
	echo -en " [-f dataFinal=$dataFinal]"
	echo -en " [-i dataInicial=$dataInicial]"
	echo ""
	exit 1
}

while getopts "v:i:f:" opt; do
	case $opt in
		v)
			valorCorrecao="$OPTARG"
			;;
		i)
			dataInicial="$OPTARG"
			;;
		f)
			dataFinal="$OPTARG"
			;;
		\?)
			usage
			;;
		:)
			usage
			;;
	esac
done

URL="${URL}&valorCorrecao=$valorCorrecao"
URL="${URL}&dataInicial=$dataInicial"
URL="${URL}&dataFinal=$dataFinal"
URL="${URL}&selIndice=$selIndice"

links2 -dump "$URL"
