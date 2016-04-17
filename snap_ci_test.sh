echo "Install erlang..."
curl -O https://raw.githubusercontent.com/spawngrid/kerl/master/kerl && chmod a+x kerl
mkdir -p /var/go/deps
export MY_DEPS_PATH=/var/go/deps
set +e
./kerl update releases
./kerl cleanup 18.2.1
(./kerl list builds | grep 18.2.1) || (export MAKEFLAGS='-j3'; ./kerl build git https://github.com/erlang/otp/ OTP-18.2.1 18.2.1)
(./kerl list installations | grep 18.2.1) || (./kerl install 18.2.1 ~/.kerl/installs/18.2.1)
source ~/.kerl/installs/18.2.1/activate

echo "Install elixir..."
mkdir -p vendor/elixir
wget --no-clobber -q https://github.com/elixir-lang/elixir/releases/download/v1.2.0/precompiled.zip
unzip -o -qq precompiled.zip -d vendor/elixir
export PATH=`pwd`/vendor/elixir/bin:$PATH

echo "Fetch elixir dependencies..."
yes y | MIX_ENV=test mix do local.rebar
yes y | MIX_ENV=test mix deps.get

echo "Run Elixir tests..."
MIX_ENV=test mix test
