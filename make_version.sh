#/bin/bash

version=1.4.1-wt-0
inspath=./files
current_hash=maldet-wt.current.hash
current_version_file=maldet-wt.current.ver
current_tarball=maldetect-wt-current.tar.gz
current_sigs_ver=files/sigs/maldet-wt.sigs.ver

current_md5_sigs=files/sigs/wt-md5.dat
current_hex_sigs=files/sigs/wt-hex.dat
current_md5_hashes=files/sigs/wt-rfxn.hdb
current_hex_hashes=files/sigs/wt-rfxn.ndb

current_cleaning_dir=files/clean-wt
current_cleaning_tarball=maldet-wt-clean.tar.gz

md5sum $inspath/maldet $inspath/internals.conf $inspath/inotify/tlog $inspath/inotify/inotifywait $inspath/clean/* | awk '{print$1}' | tr '\n' ' ' | tr -d ' ' > $current_hash

cp $current_hash files/VERSION.hash

echo $version > $current_version_file

#create current version tarball
currentdirname=maldetect-$version
tar cf temp.tar -X tar_excludes .
mkdir $currentdirname
tar xf temp.tar -C $currentdirname
rm temp.tar
tar czf $current_tarball $currentdirname
rm -rf $currentdirname

#create cleaning files tarball
tar czf $current_cleaning_tarball $current_cleaning_dir

echo Version: `cat $current_version_file`
echo Hash: `cat $current_hash`
echo Sigs Version: `cat $current_sigs_ver`

scp -v -P 2222 $current_hash $current_version_file $current_tarball $current_sigs_ver $current_md5_sigs $current_hex_sigs $current_md5_hashes $current_hex_hashes $current_cleaning_tarball chris@etcet.net:/home/chris/public_html/maldetect/

rm $current_hash $current_version_file $current_tarball $current_cleaning_tarball
