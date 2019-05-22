cp Dockerfile Dockerfile.bkp

echo "RUN adduser --disabled-password --gecos \"\" -u $UID user"  >> Dockerfile
echo "RUN chown user: /home/openpose"
echo "USER user" >> Dockerfile

docker build --tag='jutanke/openpose' .

rm Dockerfile
mv Dockerfile.bkp Dockerfile