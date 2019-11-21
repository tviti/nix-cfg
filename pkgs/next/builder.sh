source $stdenv/setup

## Unpack phase
tar -xvzf $src
cd ./next-$version

## Pre-configure phase
portfile=./ports/pyqt-webengine/next-pyqt-webengine.py
venvname=next-pyqt-venv
nextvenv=${out}/${venvname}
sed -i "1s/.*/\#\!${out//\//\\/}\/${venvname}\/bin\/python/"  ${portfile}

virtualenv ${nextvenv}
source ${nextvenv}/bin/activate
pip install pyqt5 PyQtWebEngine

## Build phase
export HOME=$TMP
make QUICKLISP_DIR=./quicklisp app-bundle

## Install phase
mkdir ${out}/Applications
cp -r ./Next.app ${out}/Applications/Next.app
mkdir ${out}/bin
ln -s ${out}/Applications/Next.app/Contents/MacOS/next ${out}/bin/next
# ln -sf ${out}/Applications/Next.app /Applications/
