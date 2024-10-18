# Makefile

# Variables
PROTO_DIR := protobuffs
PYTHON_OUT := python_demo/pb
GO_OUT := go_demo/pb

# Poetry executable
POETRY := poetry

# Ensure the output directories exist
$(shell mkdir -p $(PYTHON_OUT) $(GO_OUT))

# Find all .proto files
PROTO_FILES := $(wildcard $(PROTO_DIR)/*.proto)

# Default target
all: python_protos go_protos

# Generate Python proto files using Poetry
python_protos: $(PROTO_FILES)
	cd python_demo && $(POETRY) install && $(POETRY) run python -m grpc_tools.protoc \
		-I../$(PROTO_DIR) \
		--python_out=pb \
		--grpc_python_out=pb \
		$(patsubst $(PROTO_DIR)/%,../$(PROTO_DIR)/%,$(PROTO_FILES))
	@echo "Python proto files generated."

# Generate Go proto files
go_protos: $(PROTO_FILES)
	protoc \
		-I$(PROTO_DIR) \
		--go_out=$(GO_OUT) \
		--go_opt=paths=source_relative \
		--go-grpc_out=$(GO_OUT) \
		--go-grpc_opt=paths=source_relative \
		$(PROTO_FILES)
	@echo "Go proto files generated."

# Clean generated files
clean:
	rm -rf $(PYTHON_OUT)/*_pb2*.py
	rm -rf $(GO_OUT)/*.pb.go
	@echo "Generated proto files cleaned."

# Install Python dependencies using Poetry
python_install:
	cd python_demo && $(POETRY) install
	@echo "Python dependencies installed."

.PHONY: all python_protos go_protos clean python_install