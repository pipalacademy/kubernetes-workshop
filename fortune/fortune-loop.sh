#! /bin/sh
mkdir -p /var/www
while true
do
  TEXT=`fortune -s`
  TIME=`date`
  cat > /var/www/index.html <<END
<h1>Thought of the Moment</h1>
<pre>
$TEXT
</pre>
<p><em>Last updated: $TIME
END
  echo "$TIME -- generated new fortune cookie"
sleep 5
done

