(use-modules
   (guix packages)
   ((guix licenses) #:prefix license:)
   (guix download)
   (guix build-system gnu)
   (gnu packages)
   (gnu packages autotools)
   (gnu packages guile)
   (gnu packages guile-xyz)
   (gnu packages pkg-config)
   (gnu packages texinfo)
   (guix git-download))

  (package
    (name "guile-monads")
    (version "0.1.1.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/silasfox/guile-monads")
               (commit "0.1.1.1")))
        (file-name "guile-monads-0.1.1.1-checkout")
        (sha256 (base32 "1bza0mfv3rik43fac70294a8dvc6m3xqyf4gmc7ph4w8rda9nzdi"))))
    (build-system gnu-build-system)
    (arguments `())
    (native-inputs
      `(("autoconf" ,autoconf)
        ("automake" ,automake)
        ("pkg-config" ,pkg-config)
        ("texinfo" ,texinfo)))
    (inputs `(("guile" ,guile-3.0)))
    (propagated-inputs `())
    (synopsis "")
    (description "")
    (home-page
      "https://github.com/silasfox/guile-monads")
    (license license:gpl3+))
