NAME = HouseLoanCal
OBJ = $(NAME).obj
EXE = $(NAME).exe

ML_FLAG = /c
LINK_FLAG = /subsystem:console /machine:x64 /entry:main /nologo

$(EXE): $(OBJ)
	link $(LINK_FLAG) /out:$(EXE) $(OBJ)

.asm.obj:
	ml64 $(ML_FLAG) $<

clean:
	del *.obj
