# Define variables
GRAMMAR_DIR = ./grammar
OUTPUT_DIR = ./dist
GRAMMAR_FILE = $(GRAMMAR_DIR)/Circom.g4
ANTLR4_GO = java -jar /usr/local/lib/antlr-4.13.1-complete.jar

.PHONY: all clean

all: clean $(OUTPUT_DIR) $(OUTPUT_DIR)/grammar
	$(ANTLR4_GO) -o $(OUTPUT_DIR) $(GRAMMAR_FILE)
	cp -r $(OUTPUT_DIR)/grammar/* $(OUTPUT_DIR)
	rm -rf $(OUTPUT_DIR)/grammar

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

$(OUTPUT_DIR)/grammar:
	mkdir -p $(OUTPUT_DIR)/grammar

clean:
	rm -rf $(OUTPUT_DIR)
