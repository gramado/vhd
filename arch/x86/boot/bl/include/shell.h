/*
 * File: shell.h
 *
 * Descri��o:
 *     Header para o mini-shell dentro do Boot Loader 32 bit.
 *
 * #todo: 
 *     Deixar o minishell enxuto, com poucos recursos.
 *     Deixar principalmente os recursos de configura��o 
 *     da inicializa��o.
 *
 * 2015 - Created by Fred Nora.
 */


// 
// Command support.
//


//Prompt.
char prompt[250];             
unsigned long prompt_pos;
unsigned long g_cmd_status;    //Quando o comando terminou. (string completa).


//
// Shell.
//


//Main.

int blShellMain ( int argc, char *argv[] );
	

//Initialization.
void shellInit();
int shellInitializePrompt();
//...

void shellWaitCmd();
unsigned long shellCompare();
void shellHelp();
//...

//
// End.
//

