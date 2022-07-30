baseurl="https://pse.kominfo.go.id/static/json-static"
basefolder="data"

generate () {
limit=$(($1-1))

for i in `seq 0 $limit`
do
 echo "curl -Ss \"$baseurl/$2/$i.json\" | jq '.data[].attributes' | jq -sc '.' >> $basefolder/tmp_$filename" | sh
done
cat $basefolder/tmp_$filename | jq -sc 'flatten' > $basefolder/$filename
rm $basefolder/tmp_$filename
}


avail(){

cheker=$(curl -s -I https://pse.kominfo.go.id/static/json-static/$1/0.json | grep -i "^Content-Type:" | awk '{print $2}')
    # Check if the folder is available
    if [[ $cheker == *"application/json"* ]]; then
    totalpage=$(curl -Ss "$baseurl/$1/0.json" | jq '.meta.page.lastPage')
    generate $totalpage $1 $2
    fi
}

terdaftar(){
case="LOKAL_TERDAFTAR"
lokal=$(curl -Ss "$baseurl/$case/0.json" | jq '.meta.page.lastPage')

limit_lokal=$(($lokal-1))

for i in `seq 0 $limit_lokal`
do
 echo "curl -Ss \"$baseurl/$case/$i.json\" | jq '.data[].attributes' | jq -sc '.' >> $basefolder/tmp_daftar.json" | sh
done

cat $basefolder/tmp_daftar.json | jq -sc 'flatten' > $basefolder/lokal_terdaftar.json
rm $basefolder/tmp_daftar.json
}

local_terdaftar(){
case="LOKAL_TERDAFTAR"
filename="lokal_terdaftar.json"

avail $case $filename
}

lokal_dihentikan(){
case="LOKAL_DIHENTIKAN_SEMENTARA"
filename="lokal_dihentikan.json"


avail $case $filename
}

lokal_dicabut(){
case="LOKAL_DICABUT"
filename="lokal_dicabut.json"

avail $case $filename
}


#ASING 

asing_terdaftar(){
case="ASING_TERDAFTAR"
filename="asing_terdaftar.json"

avail $case $filename
}

asing_dihentikan(){
case="ASING_DIHENTIKAN_SEMENTARA"
filename="asing_dihentikan.json"
avail $case $filename
}

asing_dicabut(){
case="ASING_DICABUT"
filename="asing_dicabut.json"

avail $case $filename
}

local_terdaftar
lokal_dihentikan
lokal_dicabut

asing_terdaftar
asing_dihentikan
asing_dicabut
