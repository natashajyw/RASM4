// Andrew Gharios & Natasha Wu
// RASM-3:
// Purpose: Get three strings from user input and perform a series of manipulations to
//			those strings using a list of functions
// 			
// Date: 10/19/2023

.global _start // Provides program starting address
	
	.equ MAX_BYTES, 1024	// Input maximum bytes
	.data 		// Data section

//Strings for output format
szHeader:		  .asciz	"Names: Natasha Wu & Andrew Gharios\nProgram: rasm4.asm\nClass: CS 3B\nDate: 11/11/2023\n"
szOutfile:		  .asciz "output.txt"
szTitle:		  .asciz  "\nRASM4 TEXT EDITOR\n"
szMem:	      	  .asciz  "Data Structure Memory Consumption: "
szBytes:		  .asciz  " bytes\n"
szNumnodes:		  .asciz  "Number of Nodes: "
szEnterstr:	 	  .asciz  "Enter string: "
szEnterline:	  .asciz  "Enter line number: "
szInvalidIn:	  .asciz  "Invalid index, not in range\n"
szInvalidIn2:	  .asciz  "Invalid input\n"
szEnd:			  .asciz  "Program ended. Thank you for using our program!\n"
szEmpty:		  .asciz  "List is empty!\n"
szEndl:			  .asciz  "\n"
szContinue:       .asciz  "\n...enter to continue..."
szFileread:  	  .asciz  "FILE READ from \"input.txt\""
szFilewrite:   	  .asciz  "FILE SAVED to \"output.txt\""
szRemove: 		  .asciz  "...has been removed...\n"
szLeftB:		  .asciz  "["
szRightB:		  .asciz  "] "

szTemp:			.skip 22	// Temporary storage for output
kbBuf:			.skip 1024	// Keyboard buffer
headPtr:		.quad 0		// headPtr
tailPtr:		.quad 0 	// tailPtr
dbLength:		.quad 0		// storage for strlength
dbIndex:		.quad 0		// index count
iBytecount:		.word 0		// Bytes space for memory usage
iNodecount:		.word 0     // Number of nodes space
chEndl:			.byte 10	// char endline
chNull:			.byte 0		// char null(\n)
 

	.text
_start: 
// ========================== Class Header ========================== //
	ldr x0,=szHeader  // Loads x0 with szHeaders address.
	bl putstring 	  // Call putstring to print header.
	
	ldr x0, =chEndl			// loads address of chEndl into x0
	bl  putch				// branch and link function putch
	
// ========================== Main loop ========================== //
mainLoop:
	// Menu title
	ldr x0,=szTitle		// load x0 with szTitles address
	bl putstring		// Output title.
	
	// Output memory consumption
	ldr x0,=szMem		// load x0 with szMems address
	bl putstring		// call putstring
	
	// convert and output iBytecount
	ldr x0,=iBytecount	// Load x0 with Bytecounts address
	ldrh w0,[x0]		// load count into w0
	ldr x1,=szTemp		// Load x1 with szTemps address
	bl int64asc			// call int64asc
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl putstring		// call putstring
	
	// Output number of nodes
	ldr x0,=szNumnodes	// load x0 with szNumnodes address
	bl putstring		// call putstring
	
	ldr x0,=iNodecount	// Load x0 with Nodecounts address
	ldrh w0,[x0]		// load count into w0
	ldr x1,=szTemp		// Load x1 with szTemps address
	bl int64asc			// call int64asc
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl putstring		// call putstring
	
	// Prompt user with menu and receive input
	bl menuinput
	
	//switch input
	cmp w0,#'1'			// Compare returned value with 1
	beq	printAll		// Branch to print all strings
	
	cmp w0,#'a'			// Compare returned value with a
	beq inKbd			// Branch to input from keyboard	
	cmp w0,#'A'			// Compare returned value with A
	beq inKbd			// Branch to input from keyboard
	
	cmp w0,#'b'			// Compare returned value with b
	beq inFile			// Branch to input from file
	cmp w0,#'B'			// Compare returned value with B
	beq inFile			// Branch to input from file
	
	cmp w0,#'3'			// Compare returned value with 3
	beq delStr			// Branch to delete a string
	
	cmp w0,#'4'			// Compare returned value with 4
	beq editStr		    // Branch to edit a string
	
	cmp w0,#'5'			// Compare returned value with 5
	beq searchStr		// Branch to search for a string
	
	cmp w0,#'6'			// Compare returned value with 6
	beq saveFile		// Branch to save file
	
	cmp w0,#'B'			// Compare returned value with B
	beq endProgram		// Branch to input from file

// ========================== printAll ========================== //
printAll:
	ldr x1,=iNodecount  // load x1 with Node count pointer
	ldr x1,[x1]			// Load value inside Inodecount into x1
	cmp x1,#0			// Compare nodecount with 0
	beq	emptyList		// branch to empty list if nodecount == 0
	mov x21,x1			// copy value into x21
	
	str x30, [sp, #-16]!	// Store the LR onto the stack
	
	ldr x0,=headPtr		// load x0 with head pointer
	mov x20,x0			// Copy address into x20
	
	
printLoop:
	ldr x0,=szLeftB		// Load x0 with Left bracket string address
	bl putstring		// branch to putstring
	
	ldr x0,=dbIndex		// Load x0 with dbIndexs address
	ldr x0,[x0]			// Load index from dbIndex into x0
	ldr x1,=szTemp		// Load szTemps address into x1
	bl int64asc			// convert from int64 to asciz
	ldr x0,=szTemp		// Load szTemps address in x0
	bl putstring		// branch to print string
	
	ldr x0,=szRightB	// Load x0 with Left bracket string address
	bl putstring		// branch to putstring

	ldr x0,[x20,#0]		// Address of current string headptr is pointing to
	bl putstring		// call putstring to print at current address
	
	ldr x0,chCr			// Load x0 with Carriage return byte
	bl putch			// Call putch
	
	ldr x0,=dbIndex		// Load dbIndexs address into x0
	ldr x1,[x0]			// Load the value inside dbIndex into x1
	add x1,x1,#1		// Increment
	str x1,[x0]			// Store incremented value back into dbIndex
	
	sub x21,x21,#1		// decrement nodeCounter Copy
	cmp x21,#0			// Check if nodeCount copy has reached 0
	beq endPrint		// Stop printing when all nodes have been traversed
	
	ldr x20,[x20,#8]	// Increment node address to next one
	b printLoop			// branch back to printing loop
	
endPrint:
	ldr x0,=dbIndex		// Load dbIndexs address into x0
	mov x1,#0			// Move a 0 into x1
	str x1,[x0]			// Reset dbIndex to 0
	
	ldr x30, [sp], #16	// reload LR from stack
	
	RET 				// Return

emptyList:
	ldr x0,=szEmpty		// Load x0 with szEmptys address
	bl putstring		// call putstring
	
	b mainLoop			// Branch back to mainLoop to continue program

// ========================== inKeyboard ========================== //
inKbd:
	//Input from Keyboard
	ldr x0,=szTemp		// Load x0 with szTemps address
	mov x1,MAX_BYTES	// Move into x1 MAX_BYTES constant
	bl getstring
	
	ldr x0,=iNodecount	// Load x0 with Nodecounts address
	ldr x0,[x0]			// Load value in nodecounts address into x0
	cmp x0,#0			// Check if nodecount is 0
	beq addFirst		// Branch to addFirst if its the Firstnode in the list
	
	b addTail			// Otherwise branch to addTail

// ========================== inFile ========================== //
inFile:

// ========================== delStr ========================== //
delStr:

// ========================== editStr ========================== //
editStr:

// ========================== searchStr ========================== //
searchStr:

// ========================== saveFile ========================== //
saveFile:





// ========================== addFirst ========================== //
addFirst:
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl String_length	// Branch to string length
	add x0,x0,#1		// Add an extra byte for null
	
	ldr x1,=dbLength	// Load dbLengths address into x1
	str x0,[x1]			// Store returned stringlength into dbLength(x1)
	bl malloc			// Malloc space for new Node
	
	ldr x1,=szTemp		// Load szTemps address into x1
	mov x20,#0			// Initialize x20 to 0 for index
	mov x21,#0			// Initialize x21 to 0 for new string index
	
addFirstLoop:
	ldrb w2,[x1,x20]	// Load first byte of string to copy into w2
	strb w2,[x0,x21]	// Store the byte in w2 into new mallocd space
	
	add x20,x20,#1		// Index++
	add x21,x21,#1		// Index++
	
	ldr x19,=dbLength	// Load saved strlengths address into x19
	ldr x19,[x19]		// Load value from address into x19
	cmp x21,x19			// Compare index with strlength
	bne addFirstLoop	// Loop back to beginning to keep adding
	
	mov x22,x0			// Copy address of mallocd space into x22
	mov x0,#16			// mov 16 into x0
	bl malloc			// Malloc 16 bytes
	
	str x22,[x0]		// Point new mallocd node to mallocd string
	
	ldr x1,=headPtr		// Load headPtrs address into x1
	str x0,[x1]			// Point headptr to new mallocd Node
	mov x0,#0			// Move a 0 into x0
	str x0,[x1,#8]		// Point first Nodenext* to 0(Null)
	
	ldr x1,=tailPtr		// Load tailPtrs address into x1
	ldr x0,=headPtr		// Load headPtrs address into x0
	ldr x0,[x0]			// Load address headPtr is pointing to
	str x0,[x1]			// Point tail to the same address
	
	mov x1,#1			// Move a 1 into x1
	ldr x0,=iNodecount	// Load Nodecounts address into x0
	str x1,[x0]			// Store 1 into nodecount
	
	//calculate bytes
	ldr x0,iBytecount	// Load Bytecounts address into x0
	ldr x2,[x0]			// Copy value in Bytecount into x2
	add x1,x1,x2		// add Bytecount with with saved value in x1
	str x1,[x0]			// Store new bytecount from x1 into the address
	
	b mainLoop			// Jump back to beginning of program when node has been added

// ========================== addTail ========================== //
addTail:
	ldr x0,=szTemp		// Load szTemps address into x0
	bl String_length	// Branch to string length
	add x0,x0,#1		// Add an extra byte for null
	
	ldr x1,=dbLength	// Load dbLengths address into x1
	str x0,[x1]			// Store strlength into dbLengths address
	bl malloc			// Branch to malloc
	
	ldr x1,=szTemp		// Load szTemps address into x1
	mov x20,#0			// Initialize x20 to 0 for index
	mov x21,#0			// Initialize x21 to 0 for new string index
	
addTailLoop:
	ldrb w2,[x1,x20]	// Load first byte of string to copy into w2
	strb w2,[x0,x21]	// Store the byte in w2 into new mallocd space
	
	add x20,x20,#1		// Index++
	add x21,x21,#1		// Index++
	
	ldr x19,=dbLength	// Load saved strlengths address into x19
	ldr x19,[x19]		// Load value from address into x19
	cmp x21,x19			// Compare index with strlength
	bne addTailLoop		// Loop back to beginning to keep adding
	
	mov x22,x0			// Copy address of mallocd space into x22
	mov x0,#16			// mov 16 into x0
	bl malloc			// Malloc 16 bytes
	
	str x22,[x0]		// Point new mallocd node to mallocd string
	
	ldr x1,=tailPtr		// Load tailPtrs address into x1
	str x1,[x1]			// load node that tailPtr is pointing to
	str x0,[x1,#8]		// Point tailPtr to new mallocd space
	ldr x1,=tailPtr		// Load tailPtrs address into x1
	str x0,[x1]			// Point tail to the same address
	
	ldr x0,=iNodecount	// Load Nodecounts address into x0
	ldr x1,[x0]			// Copy nodecount into x1
	add x1,x1,#1		// increment nodecount by 1
	str x1,[x0]			// Store new nodecount
	
	//calculate bytes
	ldr x0,iBytecount	// Load Bytecounts address into x0
	ldr x2,[x0]			// Copy value in Bytecount into x2
	add x1,x1,x2		// add Bytecount with with saved value in x1
	str x1,[x0]			// Store new bytecount from x1 into the address
	
	b mainLoop			// Jump back to beginning of program when node has been added

endProgram:
// ========================== _end ========================== //
_end:
// End of program parameters
	mov X0, #0  			// 0 to return
	mov X8, #93 			// Linux code 93 terminates
	svc 0	    			// Call Linux to execute


// ============================================================== //
// ====================== HELPER FUNCTIONS ====================== //
// ============================================================== //

//**GETCHAR**//	
getchar:
	mov x2, #1		// mov 1 into x2
	mov x8, #NR_read // read
	svc 0			// does the lr change
	RET				// Return char
	
//**GETLINE**//
getline:
	str x30, [sp, #-16]!	// Store the LR onto the stack
	
top:
	bl getchar		// Branch to getchar
	ldrb w2,[x1]	// load byte in x1 into w2
	
	cmp w2, #0x0a	// Is char LF?
	beq EOLINE		// branch to end of line
	
	cmp w0, #0x0	// nothing read from file
	beq EOF			// branch to end of line
	
	cmp w0, #0x0	// compare byte with 0x0
	blt ERROR		// branch to error
	
	add x1, x1, #1	// increment x1
	
	ldr x0, =iFD	// Load iFDs address into x0
	ldrb w0, [x0]	// Reload the File descriptor byte into w0
	b top			// branch to top

EOLINE:
	mov w2, #0		// store null at the end of fileBuf replacing the lineFeed
	strb w2, [x1]	// store w2 into x1
	b skip			// branch to skip
	
EOF:
	ldr x0, =szEOF	// Load szEOFs address into x0
	mov x0, x19		// copy x19 into x0
	b skip			// branch to skip
	
ERROR:
	mov x19, x0			// copy x0 into x19
	ldr x0, =szERROR	// load x0 with szErrors address
	bl putstring		// Output error string
	mov x0, x19			// copy x19 back into x0
	b skip				// branch to skip
	
skip:
	ldr x30, [sp], #16	// reload LR from stack
	RET					// return getline
	