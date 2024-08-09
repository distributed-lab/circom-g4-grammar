# Define variables
GRAMMAR_DIR = ./grammar
OUTPUT_DIR = ./dist
GRAMMAR_FILE = $(GRAMMAR_DIR)/Circom.g4
ANTLR4_GO = java -jar /usr/local/lib/antlr-4.13.1-complete.jar
GRUN = java -Xmx500M -cp /usr/local/lib/antlr-4.13.1-complete.jar:$(OUTPUT_DIR) org.antlr.v4.gui.TestRig

.PHONY: all clean

all: clean $(OUTPUT_DIR) $(OUTPUT_DIR)/grammar
	$(ANTLR4_GO) -o $(OUTPUT_DIR) $(GRAMMAR_FILE)
	cp -r $(OUTPUT_DIR)/grammar/* $(OUTPUT_DIR)
	rm -rf $(OUTPUT_DIR)/grammar
	javac $(OUTPUT_DIR)/*.java

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

$(OUTPUT_DIR)/grammar:
	mkdir -p $(OUTPUT_DIR)/grammar

show:
	javac $(OUTPUT_DIR)/*.java
	$(GRUN) Circom circuit -gui

test:
	go generate ./...
	go test

clean:
	rm -rf $(OUTPUT_DIR)
