#!/bin/bash

URL="https://www3.bcb.gov.br/CALCIDADAO/publico/corrigirPeloCDI.do?method=corrigirPeloCDI"

valorCorrecao="1000,00"
dataFinal="$(date +%d/%m/%Y -d '-1day')"	# yesterday
dataInicial="01/01/$(date +%Y)" # first day of the year
percentualCorrecao= 	# non mandatory, default = 100,00

usage() {
	echo -en "Usage: $0"
	echo -en " [-v valorCorrecao=$valorCorrecao]"
	echo -en " [-f dataFinal=$dataFinal]"
	echo -en " [-i dataInicial=$dataInicial]"
	echo -en " [-p percentualCorrecao=100,00]"
	echo ""
	exit 1
}

while getopts "v:i:f:p:" opt; do
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
		p)
			percentualCorrecao="$OPTARG"
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
[ -n "$percentualCorrecao" ] && URL="${URL}&percentualCorrecao=$percentualCorrecao"

elinks -dump "$URL"
