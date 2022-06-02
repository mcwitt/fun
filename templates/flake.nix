{
  description = "Templates for small coding experiments or exercises";

  outputs = _: {
    templates = {
      haskell = {
        path = ./haskell;
        description = "Haskell template";
      };
    };
  };
}
