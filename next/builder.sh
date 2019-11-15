source $stdenv/setup

# Build Next
export QUICKLISP_DIR="./quicklisp"

tar -xvzf $src

cd ./next-$version

# Setup python env
nextvenv=${out}/next-pyqt-venv
nextpy="${out}/next-pyqt-venv/bin/python"
sed -i "1s/.*/\#\!${out//\//\\/}\/next-pyqt-venv\/bin\/python/" ./ports/pyqt-webengine/next-pyqt-webengine.py

virtualenv ${nextvenv}
source ${nextvenv}/bin/activate
pip install pyqt5 PyQtWebEngine


export HOME=$TMP
make app-bundle
mkdir ${out}/Applications
cp -r ./Next.app ${out}/Applications/Next.app
# make DESTDIR=${out} install


