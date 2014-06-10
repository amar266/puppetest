require 'facter'
Facter.add(:glance_user) do
  confine :kernel=> :linux
    setcode do
         %x{grep glance /etc/passwd |cut -f1 -d:}.chomp

end
end

