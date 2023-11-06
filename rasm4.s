// Andrew Gharios & Natasha Wu
// RASM-3:
// Purpose: Get three strings from user input and perform a series of manipulations to
//			those strings using a list of functions
// 			
// Date: 10/19/2023

.global _start // Provides program starting address

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

szTemp:			.skip 16	// Temporary storage for output
kbBuf:			.skip 1024	// Keyboard buffer
head:			.quad 0		// headPtr
tail:			.quad 0 	// tailPtr
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


printAll:

inKbd:

inFile:

delStr:

editStr:

searchStr:

saveFile:

endProgram:
// ========================== _end ========================== //
_end:
// End of program parameters
	mov X0, #0  			// 0 to return
	mov X8, #93 			// Linux code 93 terminates
	svc 0	    			// Call Linux to execute



