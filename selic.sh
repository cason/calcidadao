#!/bin/bash

URL="https://www3.bcb.gov.br/CALCIDADAO/publico/corrigirPelaSelic.do?method=corrigirPelaSelic"

valorCorrecao="1000,00"
dataFinal="$(date +%d/%m/%Y)"	# today
dataInicial="01/01/$(date +%Y)" # first day of the year

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

export report_type="selic"
export report_begin_info="Resultado da Correção pela Selic"

export query_result_name="/tmp/${report_type}_query_result_$(tr -dc 0-9 < /dev/urandom  | head -c 8)"
elinks -dump "$URL" > "$query_result_name"
export begin_info=$(cat "$query_result_name" | grep -n "$report_begin_info" | awk {'gsub(":","",$1); print $1'})
export end_info=$(cat "$query_result_name" | grep -n "Valor corrigido na data final" | awk {'gsub(":","",$1); print $1'})
export lines=$(expr $end_info - $begin_info + 1)
cat "$query_result_name" | head -n $end_info | tail -n $lines
rm "$query_result_name"
