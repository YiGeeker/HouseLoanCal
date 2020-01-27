NAME = HouseLoanCal
OBJ = $(NAME).obj
EXE = $(NAME).exe

ML_FLAG = /c /coff
LINK_FLAG = /subsystem:console

$(EXE): $(OBJ)
	link $(LINK_FLAG) /out:$(EXE) $(OBJ)

.asm.obj:
	ml $(ML_FLAG) $<

clean:
	del *.obj
