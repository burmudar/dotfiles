{ cloudflare-dns-ip
, rust-overlay
, jj-starship
, copyparty
}:
[
  copyparty.overlays.default
  cloudflare-dns-ip.overlay
  rust-overlay.overlays.default
  jj-starship.overlays.default
  (final: prev: {
    jackett = prev.jackett.overrideAttrs { doCheck = false; };
  })
]
