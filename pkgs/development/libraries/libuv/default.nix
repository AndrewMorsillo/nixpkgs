{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.20.3";
  name = "libuv-${version}";

  src = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "v${version}";
    sha256 = "1a8a679wni560z7x6w5i431vh2g0f34cznflcn52klx1vwcggrg7";
  };

  patches = [ ./make-apple-frameworks-optional.patch ];

  postPatch = let
    toDisable = [
      "getnameinfo_basic" "udp_send_hang_loop" # probably network-dependent
      "spawn_setuid_fails" "spawn_setgid_fails" "fs_chown" # user namespaces
      "getaddrinfo_fail" "getaddrinfo_fail_sync"
      "threadpool_multiple_event_loops" # times out on slow machines
    ]
      # sometimes: timeout (no output), failed uv_listen
      ++ stdenv.lib.optionals stdenv.isDarwin [ "process_title" "emfile" ];
    tdRegexp = lib.concatStringsSep "\\|" toDisable;
    in lib.optionalString doCheck ''
      sed '/${tdRegexp}/d' -i test/test-list.h
    '';

  nativeBuildInputs = [ automake autoconf libtool pkgconfig ];

  preConfigure = ''
    LIBTOOLIZE=libtoolize ./autogen.sh
  '';

  enableParallelBuilding = true;

  # These should be turned back on, but see https://github.com/NixOS/nixpkgs/issues/23651
  # For now the tests are just breaking large swaths of the nixpkgs binary cache for Darwin,
  # and I'd rather have everything else work at all than have stronger assurance here.
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A multi-platform support library with a focus on asynchronous I/O";
    homepage    = https://github.com/libuv/libuv;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = with platforms; linux ++ darwin;
  };

}
