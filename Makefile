fbaas: Main.hs FizzBuzz.hs
	ghc -Wall -Werror -O2 -o $@ $<

%.hs: %.v
	@echo "module $* where" > $@
	@echo "import qualified Prelude" >> $@
	coqtop -batch -l $< | tail -n +2 >> $@

clean:
	rm -f *.hi *.o
	rm -f FizzBuzz.hs
	rm -f fbaas

.PHONY: clean
