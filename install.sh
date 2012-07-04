if [ ! -x "`which mrbc`" ]; then
  echo "It requires 'mrbc' at building environment."
  exit; 
fi

git clone https://github.com/mruby/mruby.git
