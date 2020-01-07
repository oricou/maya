# maya
Do make this docker you need

* [Autodesk Maya](https://www.autodesk.com/products/maya/overview) tarball for Linux in this directory
* a license

Make the docker:

* Edit the Dockerfile to add your license and change user (see header)
* `docker build -t maya .`

Run the docker with X11 to view Maya:

   `./run`
