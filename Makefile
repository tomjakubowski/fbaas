fbaas: Main.hs FizzBuzz.hs
	ghc -Wall -Werror -O2 -o $@ $<

%.hs: %.v
	@echo "module $* where" > $@
	coqtop -batch -l $< | tail -n +3 >> $@

clean:
	rm -f *.hi *.o
	rm -f FizzBuzz.hs
	rm -f fbaas

.PHONY: clean
