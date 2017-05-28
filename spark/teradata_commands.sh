wget --no-check-certificate https://pypi.python.org/packages/eb/70/237e11db04807a9409ed39997097118208e7814309d9bc3da7bb98d1fe3d/requests-2.6.0.tar.gz#md5=25287278fa3ea106207461112bb37050
tar -xvf ./requests-2.6.0.tar.gz
cd requests-2.6.0/
python ./setup.py install

chmod -R a+rx /usr/local/lib64/python2.6
