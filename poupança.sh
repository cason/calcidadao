#!/bin/bash

URL="https://www3.bcb.gov.br/CALCIDADAO/publico/corrigirPelaPoupanca.do?method=corrigirPelaPoupanca"

valorCorrecao="1000,00"
dataFinal="$(date +%d/%m/%Y)"	# today
dataInicial="01/01/$(date +%Y)" # first day of the year
regraNova="true"

usage() {
	echo -en "Usage: $0"
	echo -en " [-v valorCorrecao=$valorCorrecao]"
	echo -en " [-f dataFinal=$dataFinal]"
	echo -en " [-i dataInicial=$dataInicial]"
	echo -en " [-r regraNova=$regraNova]"
	echo ""
	exit 1
}

while getopts "v:i:f:r:" opt; do
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
		r)
			regraNova="$OPTARG"
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
URL="${URL}&regraNova=$regraNova"

links2 -dump "$URL"
