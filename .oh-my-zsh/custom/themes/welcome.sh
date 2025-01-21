#!/bin/bash

# Colors
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m' # Reset text formatting

# ASCII Art
dont_panic="\
                           _
 88888b   d888b  888b  88 8P 888888    88888b    888     888b  88 88  d888b 88
 88   88 88   88 88\`8b 88      88      88   88  88 88    88\`8b 88 88 88   \` 88
 88   88 88   88 88 88 88      88      88888P  88   88   88 88 88 88 88     88
 88   88 88   88 88 \`8b88      88      88     d8888888b  88 \`8b88 88 88   , \"\"
 88888P   \`888P  88  \`888      88      88     88     \`8b 88  \`888 88  \`888P 88
"

Cosmic_Cutie="\
                                   nnnmmm                 
                    \||\       ;;;;%%%@@@@@@       \ //,  
                     V|/     %;;%%%%%@@@@@@@@@@  ===Y//   
                     68=== ;;;;%%%%%%@@@@@@@@@@@@    @Y   
                     ;Y   ;;%;%%%%%%@@@@@@@@@@@@@@    Y   
                     ;Y  ;;;+;%%%%%%@@@@@@@@@@@@@@@    Y  
                     ;Y__;;;+;%%%%%%@@@@@@@@@@@@@@i;;__Y  
                    iiY\"\";;   \"uu%@@@@@@@@@@uu\"   @\"\";;;> 
                           Y     \"UUUUUUUUU\"     @@       
                           \`;       ___ _       @         
                             \`;.  ,====\\\=.  .;'          
                               \`\`\"\"\"\"\`==\\\=='             
                                      \`;=====             
                                        ===⠀              
"

# Fetch random quote
quote=$(fortune -a /home/thaylor/.oh-my-zsh/plugins/hitchhiker/fortunes)

echo -e "${RED}$dont_panic${RESET}"
echo -e "${GREEN}$Cosmic_Cutie${RESET}"
echo -e "${CYAN}Cosmic Cutie says: ${YELLOW}$quote${RESET}"

