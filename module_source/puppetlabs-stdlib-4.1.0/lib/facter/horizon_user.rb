require 'facter'
Facter.add(:horizon_user) do
  confine :kernel=> :linux
    setcode do
         %x{grep horizon /etc/passwd |cut -f1 -d:}.chomp

end
end

