from distutils.core import setup
import os, sys, glob

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(name="butaca",
      scripts=['butaca'],
      version='0.1.0',
      maintainer="Simon Pena",
      maintainer_email="spena@igalia.com",
      description='Butaca is an application providing movie information',
      long_description=read('butaca.longdesc'),
      data_files=[('share/applications',['butaca.desktop']),
                  ('share/butaca/qml', glob.glob('qml/*.qml')),
                  ('share/butaca/qml/images', glob.glob('qml/images/*'))],)
