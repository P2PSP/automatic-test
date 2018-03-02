#!/bin/bash
rm $HOME/TecMul/TM/*.txt #Cambiar ruta por la que contenga los txt / Change the path to txt
cd $HOME/p2psp-console/bin/ #Cambiar ruta por la que tenga el p2psp-console / Change the path to p2psp-console

while getopts "a:" opt; do
  case ${opt} in
    a)
      NUM_PEERS="${OPTARG}"
      ;;
    \?)
      echo "Invalid option: -${OPTARG}"
      ;;
  esac
done

TIME=`shuf -i 20-50 -n 1`

timeout $TIME ./splitter --source_addr 150.214.150.68 --source_port 4551 --splitter_port 8001 --channel BBB-134.ogv --header_size 30000 > $HOME/TecMul/TM/splitter.txt&

timeout $TIME ./monitor --splitter_addr 127.0.0.1 --splitter_port 8001 > $HOME/TecMul/TM/monitor.txt &

timeout $TIME vlc http://localhost:9999 &

for ((i=0; i < $NUM_PEERS; i++))
do
PORT_RANDOM=`shuf -i 2000-65000 -n 1`
echo $PORT_RANDOM
timeout $TIME ./peer --splitter_addr 127.0.0.1 --splitter_port 8001 --player_port $PORT_RANDOM > $HOME/TecMul/TM/peers$PORT_RANDOM.txt &
sleep 0.5
timeout $TIME nc localhost $PORT_RANDOM > /dev/null &

done 

sleep $TIME; cat $HOME/TecMul/TM/splitter.txt
