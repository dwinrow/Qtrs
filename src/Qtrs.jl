module Qtrs

export Qtr,quartersbetween,previousyearend,previousquarter

import Dates
import Base

struct Qtr
    date::Dates.Date
    Qtr(date::Dates.Date) = new(Dates.lastdayofquarter(date))
end
Qtr(q::String) = Qtr(Dates.lastdayofquarter(Dates.Date(parse(Int,q[1:4]),parse(Int,q[end])*3,1)))
Qtr(qtrsoffset::Int=-1,date::Dates.Date=Dates.today()) = previousquarter(Qtr(date),qtrsoffset)
quartersbetween(qtrs::Pair) = quartersbetween(Qtr(qtrs[1])=>Qtr(qtrs[2]))
function quartersbetween(qtrs::Pair{Qtr,Qtr})
    ret = Qtr[]
    qtr = qtrs[1]
    while qtr <= qtrs[2]
        push!(ret,qtr)
        qtr += Dates.Quarter(1)
    end
    ret
end
Dates.quarter(q::Qtr) = Dates.quarter(q.date)
Dates.year(q::Qtr) = Dates.year(q.date)
Base.string(q::Qtr) = "$(Dates.year(q))Q$(Dates.quarter(q))"
Base.:-(q::Qtr,r::Qtr) = Dates.Quarter(Dates.year(q.date) * 4 + Dates.quarter(q.date) - Dates.year(r.date) * 4 - Dates.quarter(r.date))
Base.:+(q::Qtr,r::Dates.Quarter) = Qtr(q.date + r)
Base.:-(q::Qtr,r::Dates.Quarter) = Qtr(q.date - r)
Base.:+(q::Qtr,r::Dates.Year) = Qtr(q.date + r)
Base.:-(q::Qtr,r::Dates.Year) = Qtr(q.date - r)
Base.:<(q::Qtr,r::Qtr) = q.date < r.date
Base.show(io::IO, q::Qtr) = print(io, string(q))
Base.show(io::IO, ::MIME"text/plain", q::Qtr) = show(io, q)

"""
    previousyearend(quarter,offset = -1)
Returns the string quarter representing the previous year end
    offset: optionally allows a number of years previous to be specified
"""

previousyearend(q::String,offset = -1) = previousyearend(Qtr(q),offset)
previousquarter(q::String,offset = -1) = previousquarter(Qtr(q),offset)
previousyearend(q::Qtr,offset = -1) = Qtr(Dates.Date(Dates.year(q)+offset,12,31))
previousquarter(q::Qtr,offset = -1) = q+Dates.Quarter(offset)


end #module Qtrs