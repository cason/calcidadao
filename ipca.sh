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
	echo -en " [-I Indice]\n\n"
	echo -en "Os índices aceitos para a opção -I são:\n"
	echo -e " 00189IGP-M\t\tIGP-M (FGV) - a partir de 06/1989"
	echo -e " 00190IGP-DI\t\tIGP-DI (FGV) - a partir de 02/1944"
	echo -e " 00188INPC\t\tINPC (IBGE) - a partir de 04/1979"
	echo -e " 00433IPC-A\t\tIPC-A (IBGE) - a partir de 01/1980 [Indice padrão]"
	echo -e " 10764IPC-E\t\tIPCA-E (IBGE) - a partir de 01/1992"
	echo -e " 00191IPC-BRASIL\tIPC-BRASIL (FGV) - a partir de 01/1990"
	exit 1
}

while getopts "v:i:f:I:" opt; do
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
		I)
			selIndice="$OPTARG"
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

export report_type="ipca"
export report_begin_info="Resultado da Correção pelo IPC-A (IBGE)"

export query_result_name="/tmp/${report_type}_query_result_$(tr -dc 0-9 < /dev/urandom  | head -c 8)"
elinks -dump "$URL" > "$query_result_name"
export begin_info=$(cat "$query_result_name" | grep -n "$report_begin_info" | awk {'gsub(":","",$1); print $1'})
export end_info=$(cat "$query_result_name" | grep -n "Valor corrigido na data final" | awk {'gsub(":","",$1); print $1'})
export lines=$(expr $end_info - $begin_info + 1)
cat "$query_result_name" | head -n $end_info | tail -n $lines
rm "$query_result_name"
