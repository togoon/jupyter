
#include <iostream>
#include <boost/asio.hpp>
#include <boost/asio/deadline_timer.hpp>
 
void handler(const boost::system::error_code& ex)
{
    //Backup
}
int main()
{
    boost::asio::io_service io_service;
    boost::asio::deadline_timer tm(io_service,boost::posix_time::seconds(5));
    tm.async_wait(handler);
    io_service.run();
 
    return 0;
