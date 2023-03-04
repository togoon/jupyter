_Pragma("once")

#include <vector>
#include <queue>
#include <thread>
#include <atomic>
#include <condition_variable>
#include <future>
#include <functional>
#include <stdexcept>

// namespace finastra
// {
#define MAX_THREAD_NUM 256

using namespace std;

class threadpool
{
private:
    using Task = function<void()>;
    vector<thread> pool;
    queue<Task> tasks;
    mutex m_lock;
    condition_variable cv_task;
    atomic<bool> stoped;
    atomic<int> idleNum;

public:
    inline threadpool(unsigned int size = 5) :stoped(false)
    {
        idleNum = size < 1 ? 1 : size;

        for (size = 0; size < idleNum; ++size)
        {
            pool.emplace_back
            (
                [this]()->void
                {
                    while (!this->stoped)
                    {
                        Task task;
                        {
                            unique_lock<mutex> lock(this->m_lock);
                            this->cv_task.wait(
                                lock,
                                [this]
                                {
                                    return this->stoped.load() || !this->tasks.empty();
                                }
                                );
                            if (this->stoped && this->tasks.empty())
                                return;
                            task = move(this->tasks.front());
                            this->tasks.pop();
                        }
                        idleNum--;
                        task();
                        idleNum++;
                    }
                }
            );
        }
    }

    inline ~threadpool()
    {
        stoped.store(true);
        cv_task.notify_all();
        for (thread& t : pool)
            if (t.joinable())
                t.join();
    }

    int getIdleCount() { return idleNum; }

    template<typename F, class... Args>
    auto commit(F&& f, Args&&... args)->std::future<decltype(f(args...))>
    {
        if (stoped.load())
            throw runtime_error("threadpool is stoped!");
        using RetType = decltype(f(args...));

        auto task = make_shared<packaged_task<RetType()> >(bind(forward<F>(f), forward<Args>(args)...));
        std::future<RetType> future = task->get_future();
        {
            lock_guard<mutex> lock(m_lock);
            tasks.emplace([task]()
                {
                    (*task)();
                }
            );
        }

        cv_task.notify_one();
        return future;
    }
};





// }

