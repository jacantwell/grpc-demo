import grpc
import demo_pb2
import demo_pb2_grpc


def run():
    with grpc.insecure_channel("localhost:50051") as channel:
        stub = demo_pb2_grpc.GreeterStub(channel)
        response = stub.SayHello(demo_pb2.HelloRequest(name="World"))
        print("Greeter client received: " + response.message)


if __name__ == "__main__":
    run()
