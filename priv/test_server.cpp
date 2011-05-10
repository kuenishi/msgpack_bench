#include <msgpack/rpc/server.h>
#include <unistd.h>

namespace rpc {
	using namespace msgpack;
	using namespace msgpack::rpc;
}  // namespace rpc

class myecho : public rpc::dispatcher {
public:
	typedef rpc::request request;

	void dispatch(request req)
	try {
		std::string method;
		req.method().convert(&method);

		if(method == "add") {
			msgpack::type::tuple<int, int> params;
			req.params().convert(&params);
			add(req, params.get<0>(), params.get<1>());

		} else if(method == "echo") {
			msgpack::type::tuple<std::string> params;
			req.params().convert(&params);
			echo(req, params.get<0>());

		} else if(method == "echo_huge") {
			msgpack::type::tuple<msgpack::type::raw_ref> params;
			req.params().convert(&params);
			echo_huge(req, params.get<0>());

		} else if(method == "err") {
			msgpack::type::tuple<> params;
			req.params().convert(&params);
			err(req);

		} else {
			req.error(msgpack::rpc::NO_METHOD_ERROR);
		}

	} catch (msgpack::type_error& e) {
		req.error(msgpack::rpc::ARGUMENT_ERROR);
		return;

	} catch (std::exception& e) {
		req.error(std::string(e.what()));
		return;
	}

	void add(request req, int a1, int a2)
	{
		req.result(a1 + a2);
	}

	void echo(request req, const std::string& msg)
	{
		req.result(msg);
	}

	void echo_huge(request req, const msgpack::type::raw_ref& msg)
	{
		req.result(msg);
	}

	void err(request req)
	{
		req.error(std::string("always fail"));
	}
};


int main(void)
{
	cclog::reset(new cclog_tty(cclog::TRACE, std::cout));
	signal(SIGPIPE, SIG_IGN);

	// run server {
	rpc::server svr;

	std::auto_ptr<rpc::dispatcher> dp(new myecho);
	svr.serve(dp.get());

	svr.listen("0.0.0.0", 18811);

	svr.start(4);
	// }

	pause();
	// // start server with 4 threads
	// myserver s;
	// s.listen("0.0.0.0", 18812).start(4);

	// // send rquest from the client
	// msgpack::rpc::client c("127.0.0.1", 18812);
	// int ret = c.call("add", 1, 2).get<int>();

	// std::cout << "call: add(1, 2) = " << ret << std::endl;
}

