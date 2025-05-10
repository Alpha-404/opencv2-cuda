You will most likely have to adjust the dockerfile if you plan to compile this on your system

after git cloning run this:

```
docker build -t opencv-cuda:build .
mkdir output
docker run --rm --gpus all -v $(pwd)/output:/output -it opencv-cuda:build bash
```

you will be placed in a shell inside the container after compiling, in this shell run
```
cp $(find /usr/local/lib -name "cv2*.so") /output/
```
this places the .so file in output. Place this in your python installs `site-packages` directory to import it.
You should probably also run `ldd NAME | grep "not found"` on the .so file to find the files to copy over from the docker container to your system.
To see what i had to copy, open copied.txt
